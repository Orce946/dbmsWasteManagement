<?php
// PHP Built-in Server Router
// This file handles all requests and routes them to index.php

if (preg_match('/\.(?:png|jpg|jpeg|gif|js|css|ico)$/i', $_SERVER['REQUEST_URI'])) {
    // Serve real files
    return false;
}

// Route all requests through index.php
require_once 'index.php';
