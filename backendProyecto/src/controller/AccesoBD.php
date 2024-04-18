<?php
namespace App\controller;
use Psr\Container\ContainerInterface;
use PDO;

class AccesoBD{

    protected $container;

        public function __construct(ContainerInterface $c){
        $this->container = $c;
        }
        private function generarParam($datos){
        $cad="(";
        foreach($datos as $campo => $valor){
            $cad .= ":$campo,";
        }
        $cad = trim($cad, ',');
        $cad .= ");";
        return $cad;
        }
//1.Admin, 2.oficinista, 3.tecnico, 4.cliente;
     
        public function crearUsrBD($datos, $recurso, $rol, $campoId){
            $passw = $datos->passw;
            unset($datos->passw);
            $params = $this->generarParam($datos);
            
            $con = $this->container->get('bd');
            $con->beginTransaction();
            try{
                $sql = "SELECT nuevo$recurso$params";
                $query = $con->prepare($sql);
                $d=[];
                foreach($datos as $clave => $valor){
                $d[$clave] = filter_var($valor, FILTER_SANITIZE_SPECIAL_CHARS);
                }
                $query->execute($d);
                $res = $query->fetch(PDO::FETCH_NUM)[0];
                //crea usr
                $sql = "SELECT nuevoUsuario(:usr, :rol, :passw);";
              
                $query = $con->prepare($sql);
                $query->execute(array(
                    'usr' => $d[$campoId],
                    'rol' => $rol,
                    'passw' => $passw
                ));
                $con->commit();
            }catch(PDOException $ex){
                print r($ex->getMessage());//se quita en produccion
                $con->rollback();
                $res = 2;
            }

            $query=null;
            $con=null;
            return $res[0];
        }

        private function rutaImg($imagen){
            $ruta = "../../../assets/img/$imagen";
            return $ruta;
        }
   
        public function crearBD($datos, $recurso){
            $params = $this->generarParam($datos);
    
            $sql = "SELECT nuevo$recurso$params";
            $d = [];
    
            foreach ($datos as $clave => $valor)
                $d[$clave] = $valor;
    
            $con = $this->container->get('bd');
    
            $query = $con->prepare($sql);
            $query->execute($d);
            $res = $query->fetch(PDO::FETCH_NUM);
    
            $query = null;
            $con = null;
    
            return $res[0];
        }

        public function crearBDArticulo($datos, $recurso){
            $params = $this->generarParam($datos);
    
            $sql = "SELECT nuevo$recurso$params";
            $d = [];
    
            foreach ($datos as $clave => $valor)
                $d[$clave] = $valor;
    
            $d['imagen1'] = $this->rutaImg($d['imagen1']);
            $d['imagen2'] = $this->rutaImg($d['imagen2']);
    
            $con = $this->container->get('bd');
            //var_dump($d);die();
            $query = $con->prepare($sql);
            $query->execute($d);
            $res = $query->fetch(PDO::FETCH_NUM);
    
            $query = null;
            $con = null;
    
            return $res[0];
        }
        public function editarBD($datos, $recurso, $id){
            
            $params = $this->generarParam($datos);
            $params = substr($params,0, 1).":id," . substr($params, 1);
            $sql = "SELECT editar$recurso$params";

            $d['id'] = $id;
            foreach($datos as $clave => $valor)
            $d[$clave] = $valor;
    
            $con = $this->container->get('bd');
            $query = $con->prepare($sql);

            
            $query->execute($d);
            $res = $query->fetch(PDO::FETCH_NUM);
            $query=null;
            $con=null;
            return $res[0];
        }

        public function editarBDProducto($datos, $recurso, $id){
            
            $params = $this->generarParam($datos);
            $params = substr($params,0, 1).":id," . substr($params, 1);
            $sql = "SELECT editar$recurso$params";

            $d['id'] = $id;
            foreach($datos as $clave => $valor)
            $d[$clave] = $valor;
            
            $d['imagen1'] = $this->rutaImg($d['imagen1']);
            $d['imagen2'] = $this->rutaImg($d['imagen2']);
    
            $con = $this->container->get('bd');
            $query = $con->prepare($sql);

            
            $query->execute($d);
            $res = $query->fetch(PDO::FETCH_NUM);
            $query=null;
            $con=null;
            return $res[0];
        }

        public function eliminarBD($id, $recurso){
            $sql = "SELECT eliminar$recurso(:id);";
        
            $con = $this->container->get('bd');
            $query = $con->prepare($sql);
        
          $query->execute(["id"=>$id]);
          $res = $query->fetch(PDO::FETCH_NUM);
          $query=null;
          $con=null;
         
        
          return $res[0] ;
        }
        
        public function buscarBD($id, $recurso){
          $sql = "CALL buscar$recurso(:id, 0);";//*** 
        
            $con=$this->container->get('bd');
            $query = $con->prepare($sql);//el preparar provoca la eliminacion de caracteres peligrosos
            $query -> execute(['id' => $id]);//*** 

            $res = $query->fetch(PDO::FETCH_ASSOC);
        
            $query = null;
            $con = null;
        
            return $res;
        }
//
        public function buscarUsr(int $id=0, string $idPersona=''){
              $con=$this->container->get('bd');
              $query = $con->prepare("CALL buscarUsuario($id, $idPersona);");//el preparar provoca la eliminacion de caracteres peligrosos
              $query -> execute();//*** 
  
              $res = $query->fetch();
          
              $query = null;
              $con = null;
          
              return $res;
          }

         //
         public function buscarNombre($id, string $tipoUsuario){
            //var_dump($id, $tipoUsuario);die();
            $proc = 'buscar' . $tipoUsuario . "(0,'$id')"; 
            $sql = "call $proc";
            $con = $this->container->get('bd');
            $query = $con->prepare($sql);
            $query->execute();
            if($query -> rowCount() > 0){
                $res = $query->fetch(PDO::FETCH_ASSOC);
            }else{
                $res = [];
            }
            $query = null;
            $con = null;
            $res = $res['nombre'];
            if(str_contains($res, " ")){
                $res = substr($res, 0, strpos($res, " "));
            } 
            return $res;
    }

        public function accederToken(string $proc, string $idPersona, string $tokenRef="")
        {
            $sql = $proc == "modificar" ? "select modificarToken(:idPersona, :tk);" :
            "call verificarToken(:idPersona, :tk);";
                $con = $this->container->get('bd');
                $query = $con->prepare($sql);
                $query->execute(["idPersona"=>$idPersona, "tk"=>$tokenRef]);
                if ($proc == "modificar") {
              
                $datos = $query->fetch(PDO::FETCH_NUM);
                }else{

                    $datos = $query->fetchColumn();
                }
                $query = null;
                $con = null;
            return $datos;
            }

        

            public function filtrarBD($datos, $args, $recurso){      
                $limite = $args['limite'];
                $pagina = ($args['pagina']-1)*$limite;
                //var_dump($limite,' ',$pagina);die();
                $cadena="";
                foreach($datos as $valor){
                $cadena .= "%$valor%&";//concatenado de valores
                }
            
                $sql = "call filtrar$recurso('$cadena',$pagina, $limite);";
                $con = $this->container->get('bd');
                $query = $con->prepare($sql);
                $query->execute();
    
                $res = $query ->fetchAll();
            
                $query=null;
                $con=null;
    
                
                $datosR['datos'] = $res;
                $datosR['regs'] = $this->numRegsBD($datos, $recurso);
    
                return $datosR;
                }

        public function numRegsBD($datos, $recurso){       
      
                $cadena="";
            foreach($datos as $valor){
            $cadena .= "%$valor%&";//concatenado de valores
            }
            
            $sql = "call numRegs$recurso('$cadena');";
            $con = $this->container->get('bd');
            $query = $con->prepare($sql);
            $query->execute();
    
            $res = $query ->fetch(PDO::FETCH_NUM)[0];
            
            $query=null;
            $con=null;
            
            return $res;
            }

            //PUT-PATCH-Propietario

        public function cambiarPropietarioBD($d){
                $params = $this->generarParam($d);
   
             $sql = "SELECT cambiarPropietario$params";

            $con = $this->container->get('bd');
            $query = $con->prepare($sql);

            $query->bindParam(':id', $d['id'], PDO::PARAM_INT);
            $query->bindParam(':idPersona', $d['idPersona'], PDO::PARAM_INT);

            $query ->execute();
            $res = $query->fetch(PDO::FETCH_NUM)[0];
            $query=null;
            $con=null;

            return $res;
            }

            public function editarUsuario(string $idPersona, int $idRol = -1, string $passwN = ''){
                $proc = $idRol == -1 ? 'select passwUsuario(:id, :passw);' : 'select rolUsuario(:id, :idRol);';

                $sql = "CALL buscarUsuario(0, $idPersona);";
                $con = $this->container->get('bd');
                $query = $con->prepare($sql);
                $query->execute();
                $usuario = $query->fetch(PDO::FETCH_ASSOC);
        
                if ($usuario) {
                    $params = ['id' => $usuario['id']];
                    $params = $idRol == -1 ? array_merge($params, ['passw' => $passwN]) :
                        array_merge($params, ['idRol' => $idRol]);
                    $query = $con->prepare($proc);
                    $retorno = $query->execute($params);
                } else {
                    $retorno = false;
                }
        
                $query = null;
                $con = null;
                return $retorno;
            }
}