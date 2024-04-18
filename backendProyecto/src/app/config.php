<?php
$container->set('config_bd', function(){
return(object)[
    "host" => "localhost",
    "bd" => "hwheelworld",
    "usr" => "root",
    "pass" => "",
    "charset" => "utf8mb4"
];

});

$container->set('clave', function(){
    return "lkd#fiodjs54396*/+'¿+";
});