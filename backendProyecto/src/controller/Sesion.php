<?php

namespace App\controller;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Firebase\JWT\JWT;
//use PDO;

class Sesion extends AccesoBD {

    const TIPO_USR = [
        1 => "Cliente",
        2 => "Oficinista",
        3 => "Administrador"
        
    ];

    private function modificarToken(string $idPersona, string $tokenRef=""){
        return $this->accederToken('modificar', $idPersona, $tokenRef);
    }

    private function verificarRefresco(string $idPersona, string $tokenRef){
        return $this->accederToken('verificar', $idPersona, $tokenRef);
    }

    public function generarTokens($idPersona, int $idRol, string $nombre){
        $key = $this->container->get('clave');// crear una clave
    
        $payload = [ // para el token normal
            'iss' => $_SERVER['SERVER_NAME'],
            'iat' => time(),
            'exp' => time() + 500, //seg
            'sub' => $idPersona,
            'idRol' => $idRol,
            'nom' => $nombre
        ];

        $payloadRef = [ //para el token de referencia
            'iss' => $_SERVER['SERVER_NAME'],
            'iat' => time(),
            'idRol' => $idRol,
        ];

        $tkRef = JWT::encode($payloadRef, $key, 'HS256'); // tk refresc
        
        $this->modificarToken(idPersona: $idPersona, tokenRef: $tkRef);

        return [
            "token" => JWT::encode($payload, $key, 'HS256'),
            "refreshToken" => $tkRef
        ];
}

    
    private function autenticar($idPersona, $passw){
        $datos = $this->buscarUsr(idPersona: $idPersona);
        return(($datos) && (password_verify($passw, $datos->passw))) ?
        ['idRol' => $datos->idRol] : null;

        var_dump($datos); die();
    }



    public function iniciar(Request $request, Response $response, $args){
        $body = json_decode($request->getbody());
        $res = $this->autenticar($args['id'], $body->passw);
        if ($res) {
            $nombre = $this->buscarNombre($args['id'], self::TIPO_USR[$res['idRol']]);
            // generar token
            
            $tokens = $this->generarTokens($args['id'], $res['idRol'], $nombre);
            $response->getBody()->write(json_encode($tokens));
            $status = 200;
        }else{
            $status = 401;
        }

        return $response
        ->withHeader('Content-type', 'Application/json')
        ->withStatus($status);
        return $response->withStatus(200);
    }

    public function cerrar(Request $request, Response $response, $args){
        $this->modificarToken(idPersona: $args['id']);
        return $response->withStatus(200);
    }

    public function refrescar(Request $request, Response $response, $args){
        $body = json_decode($request->getBody());
        $idRol = $this->verificarRefresco($args['id'], $body->tkR);
        if ($idRol) {
            $nombre = $this->buscarNombre($args['id'], self::TIPO_USR[$idRol]);
            $tokens = $this->generarTokens($args['id'], $idRol, $nombre);
        }
        
        if (isset($tokens)) {
            $response->getBody()->write(json_encode($tokens));
            $status = 200;
        }else{
            $status = 401;
        }

        return $response
        ->withHeader('Content-type', 'Application/json')
        ->withStatus($status);
    }
}