<?php 
$stopHtml = "<input name='paginationdiv__provider_stop' id='paginationdiv__provider_stop' type='hidden' value='1' />";

$listCount = count($list);
$i = 0;

echo "<table>

<tr><th>Provider</th><th>Category</th><th>Registered</th><th>Location</th><th>Founded</th></tr>";

foreach($list AS $row) {
		$i++;
		echo "

			<tr><td>".$row['name']."</td><td>".$row['category']."</td><td>".date(SHORT_DATE_FORMAT, strtotime($row['date_created']))."</td><td>".$row['address']."</td><td>".date(SHORT_DATE_FORMAT, strtotime($row['date_registered']));
		  
		   # Check whether you need to stop the loading of the next pages
		if($i == $listCount && ((!empty($n) && $listCount < $n) || (empty($n) && $listCount < NUM_OF_ROWS_PER_PAGE))){
		 echo $stopHtml;
		}
		  echo "</td></tr>";
		  }
echo "</table>";

?>

