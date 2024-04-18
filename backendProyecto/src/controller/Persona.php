<?php
namespace App\controller;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Container\ContainerInterface;
use PDO;

class Persona extends AccesoBD{
    const RECURSO = "Persona";
    const ID = 'idPersona';
    const ROL = 2;


    public function crear(Request $request, Response $response, $arg){
        $body = json_decode($request->getBody());

        $body->passw =
            password_hash($body->passwF, PASSWORD_BCRYPT, ['cost' => 10]);

        unset($body->passwF); // extrae el campo y lo borra de los parms

        $res = $this->crearUsrBD($body, self::RECURSO, self::ROL, self::ID);

        $status = match ($res) {
            '0' => 201,
            '1' => 409,
            '2' => 500
        };

        return $response->withStatus($status);
    }

//DELETE
public function eliminar(Request $request, Response $response, $args){
    $res =$this -> eliminarBD($args['id'], self::RECURSO);
    $status = $res[0] > 0 ? 200 : 404;

  return $response->withStatus($status);
}
//SEARCH
public function buscarA(Request $request, Response $response, $args){
     $id= $args['id'];//se lee lo que viene en el argumento (args), o sea la url
    
     $res = $this->buscarBD($id, self::RECURSO);
     $status = !$res ? 404 : 200;
     if ($res) {$response->getBody()->write(json_encode($res));}        
     return $response
     ->withHeader('Content-type','Application/json')
     ->withStatus($status);
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

//PUT-PATCH
public function editar(Request $request, Response $response, $args){
    $id = $args['id'];
       ///(:id, :serie, :modelo, :categoria, :descripcion)
       $body= json_decode($request->getBody(), 1);

       $res = $this ->editarBD($body, self::RECURSO, $id);
   
   $status = match($res){
       '0',0=>404,
       '1',1=>200,//se modificó correctamente y el id del artefacto sí existe
       '2',2=>409
   };
      /* $datos['codigo'] = "12345";
       $response->getBody()->write(json_encode($datos));*/
       
       return $response->withStatus($status);
}
}