<?php

    session_start();

    $descricao = $_POST['descricao'];
    $valor = $_POST['valor'];
    $forma_pagamento = $_POST['forma_pagamento'];
    $data_referencia = $_POST['data_referencia'];
    $envio = $_POST['submit'];
    $tipo_referencia = $_POST['tipo_referencia'];

    if (isset($envio)) {

        if (empty($descricao)) {
            $_SESSION['errocampodesc']="descrição";
            echo "erro descricao";    
         }
        
        if (empty($valor)) {
            $_SESSION['errocampovalor']="valor";
            echo "<br>erro de valor";
         }

        if ($forma_pagamento=='0') {
            $_SESSION['errocampoforpag']="forma de pagamento";
            echo "<br>erro de forma de pagamento";
        }

        include_once('config.php');

        $result = mysqli_query($connect,"call sp_gasto_fixo('$descricao','$valor','$forma_pagamento','$data_referencia','$tipo_referencia')");
        echo "okay";
        header("location: Formulario_g_fix.php");
    }


?>  