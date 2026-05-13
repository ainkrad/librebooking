<?php

define('ROOT_DIR', '../');

if (!file_exists(ROOT_DIR . 'config/config.php')) {
    die('Missing config/config.php. Please refer to the installation instructions.');
}

require_once(ROOT_DIR . 'Pages/LoginPage.php');
require_once(ROOT_DIR . 'Presenters/LoginPresenter.php');

// Auto-login using a specific credential.
// Set these values to the account you want to log in automatically.
// Remove or disable this block when you no longer need automatic login.
if (!isset($_POST['login'])) {
    $_POST['login'] = 'submit';
    $_POST['email'] = 'user@example.com';
    $_POST['password'] = 'password';
}

$page = new LoginPage();

if ($page->LoggingIn()) {
    $page->Login();
}

if ($page->ChangingLanguage()) {
    $page->ChangeLanguage();
}

$page->PageLoad();
