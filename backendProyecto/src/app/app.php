<?php

use DI\Container;
use Slim\Factory\AppFactory;

require __DIR__ . '/../../vendor/autoload.php';

$cont_aux = new \DI\Container(); //dependece inyection variable

AppFactory::setContainer($cont_aux);//nuestra API

//
$app = AppFactory::create();

$container = $app->getContainer();
include_once 'config.php';



$app->add(new Tuupola\Middleware\JwtAuthentication([
    "secure" => false,
      //"path" => ["/cliente"],
    "ignore" =>  ['/sesion','/categoria','/articulo','/persona','/rol','/usuario',],
    "secret" => $container ->get('clave'),
    "algorithm" => ["HS256" , "HS384"]
 ]));

 


include_once 'routes.php';//se incluyen todos estos de archivos antes de ejecutar--

include_once 'conexion.php';

$app->run();