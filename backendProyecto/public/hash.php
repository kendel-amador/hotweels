<?php

$cadenaEntrada = "Esteban123";
echo $cadenaEntrada . "<br>";

$opciones = [
'cost' => 10,
];

$entradaConHash = password_hash($cadenaEntrada, PASSWORD_BCRYPT, $opciones);

echo "Con Hash " . $entradaConHash;

$cadDigitado = "Esteban123";

if(password_verify($cadDigitado, $entradaConHash)){
echo "<br>Le llegó pa";
}else{

    echo "<br>Nada que ver";
}