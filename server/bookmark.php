<?php

  function createBookmark()
    {
      global $db;

      $owner   = $_POST[owner];
      $link    = $_POST[url];
      $pheight = $_POST[p_height];
      $pwidth  = $_POST[p_width];

      //$query  = "INSERT INTO \"Bookmarks\" (owner, url, p_height, p_width, tags) " .
      //          "VALUES ('$owner', '$link', '$pheight', '$pwidth', ARRAY['$tags'])";

	  $query  = "SELECT user_id FROM \"Users\" WHERE user_name='$owner'";
	  $result = pg_query($db, $query);
	  $owner_id  = pg_fetch_result($result, 0);

      $query  = "INSERT INTO \"Bookmarks\" (owner_id, url, p_height, p_width) " .
                "VALUES ('$owner_id', '$link', '$pheight', '$pwidth') RETURNING post_id";
      echo $query;

      $result = pg_query($db, $query);
      
      $post_id = pg_fetch_result($result, 0);
      
      if($_POST[tags])
	  {
      	// building array of tags
      	$tags   = implode("','", $_POST[tags]);
      	$tagarr = "ARRAY['" . $tags . "']";

      	foreach($tags as $tag)
      	{
			$query   = "INSERT INTO \"Tags\" (post_id, tag) VALUES ('$post_id', '$tag')";
			$result = pg_query($db, $query);
			echo $result;
      	}
	  }
    }
    

  function resizeBookmark()
    {
      global $db;

      $postid  = $_POST[post_id];
      $owner   = $_POST[owner];
      $link    = $_POST[url];
      $pheight = $_POST[p_height];
      $pwidth  = $_POST[p_width];

      $query  = "UPDATE \"Bookmarks\" " .
                "SET p_height = 'pheight', p_width = 'pwidth' " .
                "WHERE owner = '$owner' AND post_id = '$postid'";
      $result = pg_query($db, $query);
    }
?>