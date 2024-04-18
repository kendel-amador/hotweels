<?php
namespace App\controller;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class Categoria extends AccesoBD{
    const RECURSO = "Categoria";

    public function crear(Request $request, Response $response, $arg){
        $body = json_decode($request->getBody());
        $res = $this->crearBD($body, self::RECURSO);

        $status = match ($res) {
            '0' => 201,
            '1' => 409,
            '2' => 404
        };

        return $response->withStatus($status);
    }

    public function editar(Request $request, Response $response, $args){
        $id = $args['id'];
        $body = json_decode($request->getBody(), 1);
        $res = $this->editarBD($body, self::RECURSO, $id);

        $status = match ($res[0]) {
            '0' => 404,
            '1' => 200, 
            '2' => 409
        };

        return $response->withStatus($status);
    }

    //GET
public function filtrar(Request $request, Response $response, $args){

    $datos = $request->getQueryParams();
    $res = $this->filtrarBD($datos, $args, self::RECURSO);

    $response->getBody()->write(json_encode($res));

    return $response
   ->withHeader('Content-type', 'Application/json')
   ->withStatus(200);
}

public function numRegs(Request $request, Response $response, $args){
$datos = $request->getQueryParams();
$res['cant']  = $this ->numRegsBD($datos, self::RECURSO);

$response->getBody()->write(json_encode($res));

   return $response
       ->withHeader('Content-type','Application/json')
       ->withStatus(200);
   
}

    public function eliminar(Request $request, Response $response, $args){
        $res = $this->eliminarBD($args['id'], self::RECURSO);
        $status = $res[0] > 0 ? 200 : 404;

        return $response->withStatus($status);
    }

    public function buscar(Request $request, Response $response, $args){
        $id = $args['id']; 

        $res = $this->buscarBD($id, self::RECURSO);
        $status = !$res ? 404 : 200;
        if ($res) {
            $response->getBody()->write(json_encode($res));
        }

        return $response
            ->withHeader('Content-type', 'Application/json')
            ->withStatus($status);
    }

}