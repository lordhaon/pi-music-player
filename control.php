<?php
header('Content-Type: application/json');

$configFile = __DIR__ . '/config.json';
$authFile = __DIR__ . '/.auth.json';
$socket = '/tmp/mpv-socket';

// Helper function to send commands to MPV using socat
function sendMpvCommand($socket, $command) {
    if (!file_exists($socket)) {
        return false;
    }
    
    $json = json_encode($command);
    $cmd = "echo " . escapeshellarg($json) . " | socat - " . escapeshellarg($socket) . " 2>/dev/null";
    $response = shell_exec($cmd);
    
    return json_decode($response, true);
}

// Get command
$cmd = $_GET['cmd'] ?? '';

// Check auth status
if ($cmd === 'check_auth') {
    if (!file_exists($authFile)) {
        echo json_encode(['needs_setup' => true]);
    } else {
        echo json_encode(['needs_setup' => false]);
    }
    exit;
}

// Initial setup
if ($cmd === 'initial_setup') {
    $location = $_POST['location'] ?? '';
    $streamUrl = $_POST['stream_url'] ?? '';
    $password = $_POST['password'] ?? '';
    
    if (empty($location) || empty($streamUrl) || empty($password)) {
        echo json_encode(['success' => false, 'error' => 'All fields required']);
        exit;
    }
    
    // Save config
    $config = [
        'stream_url' => $streamUrl,
        'location_name' => $location
    ];
    file_put_contents($configFile, json_encode($config, JSON_PRETTY_PRINT));
    
    // Save auth
    $auth = [
        'password_hash' => password_hash($password, PASSWORD_BCRYPT),
        'created' => time()
    ];
    file_put_contents($authFile, json_encode($auth, JSON_PRETTY_PRINT));
    chmod($authFile, 0600);
    
    echo json_encode(['success' => true]);
    exit;
}

// Get config
if ($cmd === 'get_config') {
    if (file_exists($configFile)) {
        echo file_get_contents($configFile);
    } else {
        echo json_encode(['stream_url' => '', 'location_name' => 'Music Player']);
    }
    exit;
}

// Update config
if ($cmd === 'update_config') {
    $currentPassword = $_POST['current_password'] ?? '';
    $location = $_POST['location'] ?? '';
    $streamUrl = $_POST['stream_url'] ?? '';
    $newPassword = $_POST['new_password'] ?? '';
    
    // Verify password
    $auth = json_decode(file_get_contents($authFile), true);
    if (!password_verify($currentPassword, $auth['password_hash'])) {
        echo json_encode(['success' => false, 'error' => 'Invalid password']);
        exit;
    }
    
    // Update config
    $config = [
        'stream_url' => $streamUrl,
        'location_name' => $location
    ];
    file_put_contents($configFile, json_encode($config, JSON_PRETTY_PRINT));
    
    // Update password if provided
    if (!empty($newPassword)) {
        $auth['password_hash'] = password_hash($newPassword, PASSWORD_BCRYPT);
        $auth['updated'] = time();
        file_put_contents($authFile, json_encode($auth, JSON_PRETTY_PRINT));
    }
    
    echo json_encode(['success' => true]);
    exit;
}

// Load config for player commands
$config = json_decode(file_get_contents($configFile), true);
$streamUrl = $config['stream_url'] ?? '';

// Play command
if ($cmd === 'play') {
    // Kill any existing MPV
    shell_exec('sudo pkill -f "mpv.*input-ipc-server"');
    sleep(1);
    
    // Start MPV with socket and set permissions
    // NOTE: The audio device will be configured by install.sh based on detected hardware
    $command = "sudo sh -c 'mpv --no-video --audio-device=alsa/plughw:CARD=Device,DEV=0 --volume=70 --input-ipc-server=/tmp/mpv-socket " . escapeshellarg($streamUrl) . " > /dev/null 2>&1 & sleep 2 && chmod 666 /tmp/mpv-socket'";
    shell_exec($command);
    
    echo "playing";
    exit;
}

// Stop command
if ($cmd === 'stop') {
    shell_exec('sudo pkill -f "mpv.*input-ipc-server"');
    if (file_exists($socket)) {
        @unlink($socket);
    }
    echo "stopped";
    exit;
}

// Volume command
if (preg_match('/^volume\s+(\d+)$/', $cmd, $matches)) {
    $volume = intval($matches[1]);
    $result = sendMpvCommand($socket, ['command' => ['set_property', 'volume', $volume]]);
    echo "volume set to $volume";
    exit;
}

// Status command
if ($cmd === 'status') {
    $result = shell_exec('pgrep -f "mpv.*input-ipc-server"');
    
    if (!empty(trim($result))) {
        // Get volume
        $volumeData = sendMpvCommand($socket, ['command' => ['get_property', 'volume']]);
        $volume = isset($volumeData['data']) ? round($volumeData['data']) : 70;
        
        echo "playing\nvolume: {$volume}%";
    } else {
        echo "stopped\nvolume: 70%";
    }
    exit;
}

echo json_encode(['success' => false, 'error' => 'Unknown command']);
?>
