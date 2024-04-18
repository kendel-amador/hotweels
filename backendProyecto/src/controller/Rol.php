<?php
namespace App\controller;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Container\ContainerInterface;
use PDO;

class Rol extends AccesoBD{
    const RECURSO = "Rol";


public function crear(Request $request, Response $response, $arg){
    ///(:idCliente, :serie, :modelo, :categoria, :descripcion)
    $body= json_decode($request->getBody());
    $res = $this ->crearBD($body, self::RECURSO);
 
$status = match($res){
    '0'=>201,
    '1'=>409,
    '2'=>404
};
   /* $datos['codigo'] = "12345";
    $response->getBody()->write(json_encode($datos));*/
    
    return $response->withStatus($status);
}

public function numRegs(Request $request, Response $response, $args){
    $datos = $request->getQueryParams();
    $res['cant']  = $this ->numRegsBD($datos, self::RECURSO);

    $response->getBody()->write(json_encode($res));

        return $response
            ->withHeader('Content-type','Application/json')
            ->withStatus(200);
        
}

//SEARCH
public function buscar(Request $request, Response $response, $args){
    $id= $args['id'];//se lee lo que viene en el argumento (args), o sea la url
    
    $res = $this->buscarBD($id, self::RECURSO);
    $status = !$res ? 404 : 200;
if ($res) {$response->getBody()->write(json_encode($res));}

    return $response
    ->withHeader('Content-type','Application/json')
    ->withStatus($status);
}

//PUT-PATCH
public function editar(Request $request, Response $response, $args){
    $id = $args['id'];
       ///(:id, :serie, :modelo, :categoria, :descripcion)
       $body= json_decode($request->getBody(), 1);
       $res = $this ->editarBD($body, self::RECURSO, $id);
   
   $status = match($res[0]){
       '0'=>404,
       '1'=>200,//se modificó correctamente y el id del artefacto sí existe
       '2'=>409
   };
      /* $datos['codigo'] = "12345";
       $response->getBody()->write(json_encode($datos));*/
       
       return $response->withStatus($status);
}


//DELETE
public function eliminar(Request $request, Response $response, $args){
    $res =$this -> eliminarBD($args['id'], self::RECURSO);
    $status = $res[0] > 0 ? 200 : 404;

  return $response->withStatus($status);
}
//GET
public function filtrar(Request $request, Response $response, $args){

    $datos = $request->getQueryParams();
    $res = $this->filtrarBD($datos, $args, self::RECURSO);

    $status = sizeof($res) > 0 ? 200 : 204;

    $response->getBody()->write(json_encode($res));

    return $response
        ->withHeader('Content-type', 'Application/json')
        ->withStatus($status);
    }



}