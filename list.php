<?php
header("Content-Type: text/plain");
$directoryPath = '.'; // Replace with the actual directory path

// Check if the directory exists
if (is_dir($directoryPath)) {
    // Use scandir to get all files and directories
    $contents = glob($directoryPath."/*.txt");

    // Filter out '.' and '..' entries, which represent the current and parent directories
    $files = array_diff($contents, array('.', '..'));

    foreach ($files as $file) {
        echo str_replace(".txt","",str_replace("./","",$file)) . "\n";
    }
} else {
    echo "Error: Directory '$directoryPath' not found or is not a directory.\n";
}
?>
