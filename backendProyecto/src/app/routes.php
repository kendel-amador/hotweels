<?php
namespace App\controller;
use Slim\Routing\RouteCollectorProxy;
//require __DIR__ . '/../controller/Artefacto.php';

$app->group('/articulo', function(RouteCollectorProxy $articulo){

$articulo->get('/{pagina}/{limite}', Articulo::class . ':filtrar');
$articulo->get('/{id}', Articulo::class . ':buscar');//
$articulo->get('', Articulo::class . ':numRegs');
$articulo->put('/{id}', Articulo::class . ':editar');
$articulo->post('', Articulo::class . ':crear');
$articulo->delete('/{id}', Articulo::class . ':eliminar');

});

$app->group('/persona', function(RouteCollectorProxy $persona){

    $persona->get('/{pagina}/{limite}', Persona::class . ':filtrar');
    $persona->get('', Persona::class . ':numRegs');
    $persona->get('/{id}', Persona::class . ':buscarA');//
    $persona->post('', Persona::class . ':crear');
    $persona->put('/{id}', Persona::class . ':editar');
    $persona->delete ('/{id}', Persona::class . ':eliminar');
    
    });


    $app->group('/proveedor', function(RouteCollectorProxy $proveedor){

        $proveedor->get('/{pagina}/{limite}', Proveedor::class . ':filtrar');
        $proveedor->get('/{id}', Proveedor::class . ':buscar');//
        $proveedor->get('', Proveedor::class . ':numRegs');
        $proveedor->post('', Proveedor::class . ':crear');
        $proveedor->put('/{id}', Proveedor::class . ':editar');
        $proveedor->delete('/{id}', Proveedor::class . ':eliminar');
        
        });

        $app->group('/categoria', function (RouteCollectorProxy $categoria) {

            $categoria->get('/{id}', Categoria::class . ':buscar'); 
            $categoria->get('/{pagina}/{limite}', Categoria::class . ':filtrar');
            $categoria->get('', Categoria::class . ':numRegs');//
            $categoria->post('', Categoria::class . ':crear');
            $categoria->put('/{id}', Categoria::class . ':editar');
            $categoria->delete('/{id}', Categoria::class . ':eliminar');
        
        });

        
    $app->group('/rol', function(RouteCollectorProxy $rol){

        $rol->get('/{pagina}/{limite}', Rol::class . ':filtrar');
        $rol->get('/{id}', Rol::class . ':buscar');//
        $rol->get('', Rol::class . ':numRegs');//
        $rol->post('', Rol::class . ':crear');
        $rol->put('/{id}', Rol::class . ':editar');
        $rol->delete('/{id}', Rol::class . ':eliminar');
        
        });

        $app->group('/sesion', function(RouteCollectorProxy $sesion){
            $sesion->patch('/iniciar/{id}', Sesion::class . ':iniciar');
            $sesion->patch('/cerrar/{id}', Sesion::class . ':cerrar');
            $sesion->patch('/refrescar/{id}', Sesion::class . ':refrescar');
        
        });

    $app->group('/usuario', function(RouteCollectorProxy $usuario){

        $usuario->patch('/rol/{id}', Usuario::class . ':cambiarRol');
        $usuario->group('/passw', function(RouteCollectorProxy $passw){
            $passw->patch('/cambio/{id}',  Usuario::class . ':cambiarPassw');
            $passw->patch('/reset/{id}', Usuario::class . ':resetPassw');
          });
          $usuario->get('/{pagina}/{limite}', Usuario::class . ':filtrar');
            $usuario->get('/{id}', Usuario::class . ':buscar');//
            $usuario->get('', Usuario::class . ':numRegs');
            $usuario->put('/{id}', Usuario::class . ':editar');

        });


        
/*
$app->post('/artefacto', function (Request $request, Response $response, $args) {
    $codigo= $args['codigo'];
    $response->getBody()->write("Mostrando artefacto con codigo $codigo");
    return $response;
});
*/