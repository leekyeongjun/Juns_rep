<?php
    function Print_JsonList($Title){
        if($Title != null){
            foreach($Title as $ColumnText){
                echo $ColumnText.'</br>';
            }
        }
        echo '</br>';
    }

    function Print_SingleJson($Title){
        echo $Title;
        echo '</br></br>';
    }

    function Print_JsonTuple( $Title ){
        if($Title != null){
            foreach($Title as $Chunk){
                echo '<strong>'.$Chunk->Title.'</strong></br>';
                echo $Chunk->Content;
                echo '</br></br>';
            }
            echo '</br>';
        }
    }
    function PrintCardData($conn, $Id){

        $cards = mysqli_query($conn, 'SELECT * FROM Cards ORDER BY Id ASC LIMIT 1 OFFSET '.$Id);
        $row = mysqli_fetch_array($cards);

        $curInfo = mysqli_query($conn, 'SELECT * FROM Info ORDER BY Id ASC LIMIT 1 OFFSET '.$Id);
        $curInfo = mysqli_fetch_array($curInfo);

        $curSugg = mysqli_query($conn,'SELECT * FROM Suggestion ORDER BY Id ASC LIMIT 1 OFFSET '.$Id);
        $curSugg = mysqli_fetch_array($curSugg);

        $curetc = mysqli_query($conn,'SELECT * FROM EtcDetails ORDER BY Id ASC LIMIT 1 OFFSET '.$Id);
        $curetc = mysqli_fetch_array($curetc);

        $Name = json_decode('"'.$row['Name'].'"');
        $Description = json_decode($row['Description']);

        $Love = json_decode($curInfo['Love']);
        $Relationship = json_decode($curInfo['Relationship']);
        $Money = json_decode($curInfo['Money']);
        $Work = json_decode($curInfo['Work']);
        $ReMeet = json_decode($curInfo['ReMeet']);
        $Contact = json_decode($curInfo['Contact']);
        $Travel = json_decode($curInfo['Travel']);
        $MoveJob = json_decode($curInfo['MoveJob']);
        $Health = json_decode($curInfo['Health']);
        $Place = json_decode($curInfo['Place']);
        $Mood = json_decode($curInfo['Mood']);
        $Numerology = json_decode($curInfo['Numerology']);
        $Keyword = json_decode($curInfo['Keyword']);

        $Advice = json_decode($curSugg['Advice']);
        $Warning = json_decode($curSugg['Warning']);

        $Etc = Json_decode($curetc['Etc']);

        PrintCardImage($Id);
         
        echo $Id.' '.$Name.'';
        echo $Description;
        echo '</br>';
        Print_JsonList($Love);
        Print_JsonList($Relationship);
        Print_JsonList($Money);
        Print_JsonList($Work);
        Print_JsonList($ReMeet);
        Print_JsonList($Contact);
        Print_JsonList($Travel);
        Print_JsonList($MoveJob);
        Print_JsonList($Health);
        Print_JsonList($Place);
        Print_JsonList($Mood);
        Print_SingleJson($Numerology);
        Print_JsonList($Keyword);

        Print_JsonList($Advice);
        Print_JsonList($Warning);
        Print_JsonTuple($Etc);
        echo '</br></br>';
    }

?>

<?php
    $dir = 'Deck/';
    function PrintCardImage($Id){
        echo "<img src = 'Deck/".$Id.".jpg' style = 'width:100px; margin:10px;'>";
    }
?>

<?php
    $conn = mysqli_connect('localhost','root','tataro');
    mysqli_select_db($conn, 'tarotdeck');

?>


