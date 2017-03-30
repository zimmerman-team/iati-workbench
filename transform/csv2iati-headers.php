<?php

$files = glob('*.csv');
$header = array();

foreach ($files as $file) {
  if (($handle = fopen($file, "r")) !== FALSE) {
    if (($data = fgetcsv($handle)) !== FALSE) {
      $columns = array();
      unset($id);

      foreach ($data as $key => $value) {
        if (strtolower(preg_replace('/[\s-]+/', '', $value)) == 'iatiidentifier') {
          $id = array('column' => array($key => $value));
        } else {
          $columns['column'][$key] = $value;
        }
      };

      $header[$file][]=array(
        'type' => 'element',
        'name' => 'iati-activity',
        'attribs' => array(),
        'children' => array(
          0 => array(
            'type' => 'element',
            'name' => 'iati-identifier',
            'value' => array($id)
          )
        ),
        'ignore' => $columns
      );
    }
    fclose($handle);
  }
}

echo "<?php\n\$headers =" . var_export($header, true) . ';';

?>
