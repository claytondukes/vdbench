<html>
<head>
  <title>Apeiron Demo1 - Linear Scalability Menu</title>
<!-- <title>Apeiron Demo2 - Optane in ADS1000 Menu</title>-->

  <!-- meta line to make sure Dynamic text is refreshed every 5sec -->
  <meta http-equiv="refresh" content="2">

  <style type="text/css">
    body {
	font-family:verdana,arial,sans-serif;
	font-size:10pt;
	margin:10px;
	<!-- background-color:#ff9900; -->
    }
  </style>
  <!--  <script src="js/demo_vdbench.js"></script> -->
</head>

<body bgcolor=#999999>

<table width=100%>
  <tr cols=5>
    <td width=15% align=center valign=center bgcolor=#BBBBBB>
      <h3>Apeiron NVMe</br>Linear Scalability</h3>
<!--      <h3>Optane in ADS1000 Internal/External</br>Comparison</h3>-->
    </td>
    <td width=35% align=right valign=center>
      <p><b>
        <?php
           echo file_get_contents( "demo1_text.txt" ); // get the contents, and echo it out.
        ?>
         </b></p>
    </td>
    <td width=33% align=center>
<!--      <h3>VDBench Workload Read/Write=70%/30%, 4kB(18%), 52kB(41%), 152kB(41%)</h3> -->
      <p>
        <?php
           echo file_get_contents( "demo1_workload.txt" ); // get the contents, and echo it out.
        ?>

      </p>
    </td>
    <td width=12% align=center>
      <img src="Images/logo.png" height=70px border="2" valign=top>
    </td>
    <td width=5% align=right valign=center>
      <p>Scalability
<!--      <p><a href="http://10.81.60.172:2000/index1.html" target="_top">Scalability</a> -->
<!--      </br>Optane</p> -->
      </br><a href="http://10.81.60.173:2000/index2.html" target="_top">Optane</a>
    </td>
  </tr>
</table>

</body>
</html>

