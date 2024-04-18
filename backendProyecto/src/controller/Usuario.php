<?php
namespace App\controller;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class Usuario extends AccesoBD{
    const RECURSO = "Usuario";

    private function autenticar($idPersona, $passw){
        $datos = $this->buscarUsr(idPersona: $idPersona); //se le especificó el parametro al cual meter el dato idPersona
        
        return (($datos) && (password_verify($passw, $datos->passw))) ?
            ['idRol' => $datos->idRol] : null;
    }

    public function cambiarRol(Request $request, Response $response, $args){
        $body = json_decode($request->getBody());
        $datos = $this->editarUsuario($args['id'], $body->idRol);
        $status = $datos == true ? 200 : 404;
    
        return $response->withStatus($status);
    }

    public function cambiarPassw(Request $request, Response $response, $args){
        $body = json_decode($request->getBody(), 1);
        $usuario = $this->autenticar($args['id'], $body['passw']);

        if ($usuario) {
            $datos = $this->editarUsuario(idPersona: $args['id'], passwN: Hash::hash($body['passwN']));
            $status = 200;
        } else {
            $status = 401;
        }

        return $response->withStatus($status);

    }

    public function resetPassw(Request $request, Response $response, $args){ //solo lo hace el admin
        $body = json_decode($request->getBody());
        $datos = $this->editarUsuario(idPersona: $args['id'], passwN: Hash::hash($body->passwN));

        $status = $datos == true ? 200 : 404;

        return $response->withStatus($status);

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