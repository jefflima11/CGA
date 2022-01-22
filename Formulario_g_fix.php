<?php
    
   session_start();

   if (isset($_SESSION['errocampodesc'])) {
       echo "<p style='color: #FF0000;'>Campo " .$_SESSION['errocampodesc']." obrigatorio";
       unset($_SESSION['errocampodesc']);
   }
   if (isset($_SESSION['errocampovalor'])) {
    echo "<p style='color: #FF0000;'>Campo " .$_SESSION['errocampovalor']." obrigatorio";
    unset($_SESSION['errocampovalor']);
   }

   if (isset($_SESSION['errocampoforpag'])) {
    echo "<p style='color: #FF0000;'>Campo " .$_SESSION['errocampoforpag']." obrigatorio";
    unset($_SESSION['errocampoforpag']);
   }

?>


<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title></title>
</head>
<body>
    
    <form action="Envio_g_f.php" method="POST">
        <div>
            <p>Gasto Fixo Mensal</p>
            <label>Descrição: </label>
            <input type="text" name="descricao" class="descricao">
            <br>
            <label for="user">Valor: </label>
            <input type="number" name="valor" id="valor">
            <br>
            <label for="user">Forma de pagamento: </label>
            <select name="forma_pagamento" id="forma_pagamento">
                <option value="0"></option>
                <option value="1">Virtual</option>
                <option value="2">Fisica</option>
                <option value="3">Boleto</option>
            </select>
            <br>
            <label for="user">Data de referencia: </label>
            <input type="date" name="data_referencia" id="Data_referencia">
            <br>
            <label for="user">Tipo de Referencia: </label>
            <select name="tipo_referencia" id="tipo_referencia">
                <option value="0"></option>
                <option value="1">1ª quinzena</option>
                <option value="2">2ª quinzena</option>
            </select>
        </div>

        <div>
            <input type="submit" name="submit" id="submit">
        </div>
    </form>

</body>
</html>