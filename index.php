<?php
declare(strict_types=1);

function adminer_object()
{
    // required to run any plugin
    include_once "../plugins/plugin.php";

    // autoloader
    foreach (glob("../plugins/*.php") as $filename) {
        include_once $filename;
    }

    // enable extra drivers just by including them
    //~ include "../plugins/drivers/simpledb.php";

    $plugins = array();
    if (getenv('DB_SSL_CA_FILE') !== false && getenv('DB_SSL_CA_FILE') !== '') {
        $filepath = '/tmp/db.crt.pem';
        if (!file_exists($filepath)) {
            file_put_contents($filepath, getenv('DB_SSL_CA_FILE'));
        }
        $plugins = array(
            // specify enabled plugins here
            new AdminerLoginSsl(array("ca" => $filepath)),
        );
    }

    /* It is possible to combine customization and plugins:
    class AdminerCustomization extends AdminerPlugin {
    }
    return new AdminerCustomization($plugins);
    */

    include_once('plugins/login-password-less.php');
    return new \AdminerPlugin(array(
        new \AdminerLoginPasswordLess(password_hash("test", PASSWORD_DEFAULT)),
    ));

    return new AdminerPlugin($plugins);
}

chdir('./adminer');

// include original Adminer or Adminer Editor (usually named adminer.php)
include "./index.php";
