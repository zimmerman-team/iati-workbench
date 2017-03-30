<?php
$csvns = "http://iati.me/csv";
// $activities = new SimpleXMLElement('<iati-activities xmlns:csv="' . $csvns . '" />');
$activities = new SimpleXMLElement('<iati-activities/>');
$activities->addAttribute('version', '2.02');
$activities->addAttribute('generated-datetime', date('c'));

$files = glob('*.csv');

/**
 * Process data, return as string
 */
function processString($data, $config)
{
  $result = '';

  if (is_array($config)) {
    foreach ($config as $key => $value) {
      if (is_array($value)) {
        foreach ($value as $v_key => $v_value) {
          switch ($v_key) {
            case 'column':
              foreach ($v_value as $c_key => $c_name) {
                $result .= $data[$c_key];
              }
              break;

            case 'text':
              $result .= $v_value;
              break;

            default:
              break;
          }
        }
      }
      // if (is_array($value) && array_key_exists('column', $value)) {
      //   foreach ($value['column'] as $c_key => $c_name) {
      //     $result .= $data[$c_key];
      //   }
      // }
    }
  }

  return $result;
}

/**
 *  Process data, return as XML string
 */
function processXML($xml, $data, $config, $file, $row)
{
  global $csvns;

  if (is_array($config)) {
    foreach ($config as $key => $part) {
      switch ($part['type']) {
        case 'element':
          $value = '';

          if (array_key_exists('value', $part)) {
            $value = htmlspecialchars(processString($data, $part['value']));
          }

          $c = $xml->addChild($part['name'], $value);

          // if ($value != '') {
          //   $s = $c->addChild('source', '', $csvns);
          //   $s->addAttribute('file', $file);
          //   $s->addAttribute('line', $row);
          // }

          if (array_key_exists('attribs', $part)) {
            foreach ($part['attribs'] as $a_key => $a_part) {
              $c->addAttribute($a_key, processString($data, $a_part));
            }
          }

          if (array_key_exists('children', $part)) {
            $c = processXML($c, $data, $part['children'], $file, $row);
          }

          break;

        default:
          // that shouldn't happen...
          break;
      }
    }

  }

  return $xml;
}

require_once('headers-config.php');

foreach ($files as $file) {
  if (array_key_exists($file, $headers)) {
    $row = 1;
    $fileconfig = $headers[$file];

    if (($handle = fopen($file, "r")) !== FALSE) {
      // skip the first row:
      if (($data = fgetcsv($handle)) !== FALSE) {
        while (($data = fgetcsv($handle)) !== FALSE) {
          $row++;
          $activities = processXML($activities, $data, $fileconfig, $file, $row);
        };
      }
      fclose($handle);
    }

  }
}

echo $activities->asXML();

?>
