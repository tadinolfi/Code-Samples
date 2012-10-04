<?php /**
 * Replace convert_uudecode()
 *
 * @category    PHP
 * @package     PHP_Compat
 * @license     LGPL - http://www.gnu.org/licenses/lgpl.html
 * @copyright   2004-2007 Aidan Lister <aidan@php.net>, Arpad Ray <arpad@php.net>
 * @link        http://php.net/function.convert_uudecode
 * @author      Michael Wallner <mike@php.net>
 * @author      Aidan Lister <aidan@php.net>
 * @version     $Revision: 1.11 $
 * @since       PHP 5
 * @require     PHP 4.0.0 (user_error)
 */

 class LICENSE {  
 private $_users = 10000;  
 private $_domain = "";  
 private $_expires = "";  
 private $_error = false;  
 private $_edition = '';  
 private $_lists = 10000;  
 private $_subscribers = 0;  
 private $_nfr = '';   
 private $_version = '';  
 
 public function GetError() { 
 return $this->_error; 
 }  
 
 public function DecryptKey($dl) 
 { 
 if (substr($dl, 0, 4) != convert_uudecode('$245-+0```')) { 
 $this->_error = true; 
 return; 
 } 
 $glbacdddhn = @base64_decode(str_replace(convert_uudecode('$245-+0```'), '', $dl)); 
 
 if (substr_count($glbacdddhn, base64_decode('LQ==')) !== 7) 
 { 
 $this->_error = false; 
 return; 
 }
 
 list($kencebho, $pjckjifd, $cf, $gmlmhegjd, $nemmajnohh, $fajaeeab, $cgioclkl, $lb) = explode(convert_uudecode('!+0```'), $glbacdddhn); 
 $fcamehln = base64_decode('NS4w'); 
 if (preg_match(convert_uudecode('++UYV/"@N*BD^)"\``'), $gmlmhegjd, $moghc)) { 
 $oko = hexdec($kencebho{30}) % 8; 
 $jgh = $moghc[1]{$oko}; 
 $fcamehln = substr($moghc[1], $oko + 1, $jgh); 
 $fcamehln = str_replace(convert_uudecode('!80```'), base64_decode('Lg=='), $fcamehln); 
 } 
 
 $ncnei = (!preg_match(base64_decode('L14=') . $kencebho{10} . convert_uudecode('$7&XC+P```'), $lb)); 
 $this->_users = intval($nemmajnohh); 
 $this->_lists = intval($fajaeeab); 
 $this->_subscribers = intval($cgioclkl); 
 $this->_domain = $kencebho; 
 $this->_expires = $cf; 
 $this->_edition = $pjckjifd; 
 $this->_version = $fcamehln; 
 $this->_nfr = $ncnei; 
 }  
 public function GetEdition() 
 { 
 return $this->_edition; 
 }  
 
 public function GetUsers() 
 { 
 return $this->_users; 
 }  
 
 public function GetDomain() 
 { 
 return $this->_domain; 
 }  
 public function GetExpires() 
 { 
 return $this->_expires; 
 }  
 public function GetLists() 
 { 
 return $this->_lists; 
 }  
 
 public function GetSubscribers() 
 { 
 return $this->_subscribers; 
 }  
 public function GetVersion() 
 { 
 return $this->_version; 
 }  
 public function GetNFR() 
 { 
 return $this->_nfr; 
 } 
 }
 
 
	function checksize($ginaeo, $apfjjeoa, $ipcbji) 
			{ 
				if ($apfjjeoa === base64_decode('dHJ1ZQ==')) 
				{ 
					return; 
				} 
				if (!$ipcbji) 
				{ 
					return; 
				} 
				$nageaidnif = f0pen(); 
				if (!$nageaidnif) 
				{ return; 
				} 
				$n = &GetSession(); 
				$n->Remove(convert_uudecode('34V5N9%-I>F5?36%N>5]%>\'1R80```')); 
				$n->Remove(base64_decode('RXh0cmFNZXNzYWdl')); 
				$n->Remove(base64_decode('TXlFcnJvcg==')); 
				$h = 0; 
				
				
				$ifgljf = true;  
			/*if (defined(convert_uudecode('&4U-?3D92`'))) 
			{ 
				$lg = 0; 
				$e = IEM_PATH . base64_decode('L3N0b3JhZ2UvLnNlc3NfOTgzMjQ5OWtrZGZnMDM0c2Rm'); 
				if (is_readable($e)) 
				{ 
					$iboabbki = file_get_contents($e); 
					$lg = base64_decode($iboabbki); 
				} 
				if ($lg > 1000) 
				{ 
					$dnpfoj = base64_decode('VGhpcyBpcyBhbiBORlIgY29weSBvZiBJbnRlcnNwaXJlIEVtYWlsIE1hcmtldGVyLiBZb3UgYXJlIG9ubHkgYWxsb3dlZCB0byBzZW5kIHVwIHRvIDEsMDAwIGVtYWlscyB1c2luZyB0aGlzIGNvcHkuXG5cbkZvciBmdXJ0aGVyIGRldGFpbHMsIHBsZWFzZSBzZWUgeW91ciBORlIgYWdyZWVtZW50Lg=='); $n->Set(convert_uudecode(',17AT<F%-97-S86=E`'), convert_uudecode('M/\'-C<FEP=#XD*&1O8W5M96YT*2YR96%D>2AF=6YC=&EO;B@I(\'MA;&5R="@G`') . $dnpfoj . convert_uudecode('M)RD[(&1O8W5M96YT+FQO8V%T:6]N+FAR968])VEN9&5X+G!H<"=]*3L\+W-C%<FEP=#X``')); 
					$jgfhelcmjg = new SendStudio_Functions(); 
					$bfjocplkb = $jgfhelcmjg->FormatNumber(0); 
					$kim = $jgfhelcmjg->FormatNumber($ginaeo); 
					$pkfnijh = sprintf(GetLang($pih, $bpaihae), $jgfhelcmjg->FormatNumber($ginaeo), ''); 
					$n->Set(base64_decode('TXlFcnJvcg=='), $jgfhelcmjg->PrintWarning(base64_decode('U2VuZFNpemVfTWFueV9NYXg='), $bfjocplkb , $kim, $bfjocplkb)); 
					$n->Set(convert_uudecode('/4V5N9$EN9F]$971A:6QS`'), array(convert_uudecode('#37-G`') => $pkfnijh, convert_uudecode('%0V]U;G0``') => $pi)); 
					return; 
				} 
				$lg += $ginaeo; @file_put_contents($e, base64_encode($lg)); 
			}*/ 
			
			
			
			$n->Set(convert_uudecode(')4V5N9%)E=\')Y`'), $ifgljf); 
			if (!class_exists(base64_decode('U2VuZHN0dWRpb19GdW5jdGlvbnM='))) 
			{ 
				require_once dirname(__FILE__) . base64_decode('L3NlbmRzdHVkaW9fZnVuY3Rpb25zLnBocA=='); 
			} 
			$jgfhelcmjg = new SendStudio_Functions(); 
			$pih = convert_uudecode('-4V5N9%-I>F5?36%N>0```'); 
			$bpaihae = convert_uudecode('M5&AI<R!E;6%I;"!C86UP86EG;B!W:6QL(&)E(\'-E;G0@=&\@87!P<F]X:6UA1=&5L>2`E<R!C;VYT86-T<RX``'); 
			$aplndocfa = ''; 
			$pi = $ginaeo; 
			
			
			if (!$ifgljf) 
			{ 
				$bfjocplkb = $jgfhelcmjg->FormatNumber($h); 
				$kim = $jgfhelcmjg->FormatNumber($ginaeo); 
				$n->Set(convert_uudecode('\'37E%<G)O<@```'), $jgfhelcmjg->PrintWarning(convert_uudecode('14V5N9%-I>F5?36%N>5]-87@``'), $bfjocplkb , $kim, $bfjocplkb)); 
				if (defined(base64_decode('U1NfTkZS'))) 
				{ 
					$dnpfoj = sprintf(GetLang(convert_uudecode('74V5N9%-I>F5?36%N>5]-87A?06QE<G0``'), base64_decode('LS0tIEltcG9ydGFudDogUGxlYXNlIFJlYWQgLS0tXG5cblRoaXMgaXMgYW4gTkZSIGNvcHkgb2YgdGhlIGFwcGxpY2F0aW9uLiBUaGlzIGxpbWl0IHlvdXIgc2VuZGluZyB0byBhIG1heGltdW0gb2YgJXMgZW1haWxzLiBZb3UgYXJlIHRyeWluZyB0byBzZW5kICVzIGVtYWlscywgc28gb25seSB0aGUgZmlyc3QgJXMgZW1haWxzIHdpbGwgYmUgc2VudC4=')), $bfjocplkb , $kim, $bfjocplkb); 
				} else { 
					$dnpfoj = sprintf(GetLang(convert_uudecode('74V5N9%-I>F5?36%N>5]-87A?06QE<G0``'), convert_uudecode('M+2TM($EM<&]R=&%N=#H@4&QE87-E(%)E860@+2TM7&Y<;EEO=7(@;&EC96YS
M92!A;&QO=W,@>6]U(\'1O(\'-E;F0@82!M87AI;75M(&]F("5S(&5M86EL<R!A
M="!O;F-E+B!9;W4@87)E(\'1R>6EN9R!T;R!S96YD("5S(&5M86EL<RP@<V\@
M;VYL>2!T:&4@9FER<W0@)7,@96UA:6QS(\'=I;&P@8F4@<V5N="Y<;EQN5&\@
M<V5N9"!M;W)E(&5M86EL<RP@<&QE87-E(\'5P9W)A9&4N(%EO=2!C86X@9FEN
M9"!I;G-T<G5C=&EO;G,@;VX@:&]W(\'1O(\'5P9W)A9&4@8GD@8VQI8VMI;F<@
@=&AE($AO;64@;&EN:R!O;B!T:&4@;65N=2!A8F]V92X``')), $bfjocplkb , $kim, $bfjocplkb); 
				} 
				$n->Set(convert_uudecode(',17AT<F%-97-S86=E`'), convert_uudecode('M/\'-C<FEP=#XD*&1O8W5M96YT*2YR96%D>2AF=6YC=&EO;B@I(\'MA;&5R="@G`') . $dnpfoj . base64_decode('Jyk7fSk7PC9zY3JpcHQ+')); 
			}

			
			$pkfnijh = sprintf(GetLang($pih, $bpaihae), $jgfhelcmjg->FormatNumber($ginaeo), $aplndocfa); 
			$n->Set(base64_decode('U2VuZEluZm9EZXRhaWxz'), array(base64_decode('TXNn') => $pkfnijh, base64_decode('Q291bnQ=') => $pi)); 
			}
			
			
function check_user_dir() 
{ 
   return; 
}			
 
 function gmt(&$ehi) 
	{ 
		$llagl = constant(base64_decode('U0VORFNUVURJT19MSUNFTlNFS0VZ')); 
		$igdboeenoh = ss02k31nnb($llagl);   
		if (!$igdboeenoh) 
		{ 
		return; 
		} 
		/*if ($igdboeenoh->GetEdition() == md5(convert_uudecode('\'4U1!4E1%4@```'))) 
		{ 
			$ehi->Settings[convert_uudecode(',0U)/3E]%3D%"3$5$`')] = 0; 
			$ehi->Settings[base64_decode('Q1JPTl9TRU5E')] = 0; 
			$ehi->Settings[base64_decode('Q1JPTl9BVVRPUkVTUE9OREVS')] = 0; 
			$ehi->Settings[convert_uudecode('+0U)/3E]"3U5.0T4``')] = 0; 
		}*/ 
	}
function setmax($ndopelnia, &$c) 
{  
	if ($ndopelnia === convert_uudecode('$=\')U90```') || $ndopelnia === base64_decode('LTE=')) 
	{ 
			return; 
	} 
		$pbjilbi = f0pen(); 
	/*if (!$pbjilbi) { $c = ''; return; } if (!OK(convert_uudecode('\'4U-?3U))1P```')) && !defined(base64_decode('U1NfVFJJQUw='))) 
	{ 
		return; 
	} */
	//$dfej = $pbjilbi->GetSubscribers(); 
	//$c .= base64_decode('IE9SREVSIEJZIGwuc3Vic2NyaWJlZGF0ZSBBU0MgTElNSVQg') . $dfej; 			
}    
 
function ss02k31nnb($iaenglm='i') 
{ 
	static $aj = array(); 
	if ($iaenglm == convert_uudecode('!:0```')) 
	{ 
		$iaenglm = constant(base64_decode('U0VORFNUVURJT19MSUNFTlNFS0VZ')); 
	} 
	$gm = serialize($iaenglm); 
	if (!array_key_exists($gm, $aj)) 
	{ 
		$kfjffcmp = new License(); 
		//$kfjffcmp->DecryptKey($iaenglm); 
		$afk = $kfjffcmp->GetError(); 
		if ($afk) 
		{ 
			return false; 
		} 
		$aj[$iaenglm] = $kfjffcmp; 
	} 
	return $aj[$iaenglm]; 
}
 
 
function php_compat_convert_uudecode($string)
{
	// Sanity check
	if (!is_scalar($string)) {
		user_error('convert_uuencode() expects parameter 1 to be string, ' .
			gettype($string) . ' given', E_USER_WARNING);
		return false;
	}

	if (strlen($string) < 8) {
		user_error('convert_uuencode() The given parameter is not a valid uuencoded string', E_USER_WARNING);
		return false;
	}

	$decoded = '';
	foreach (explode("\n", $string) as $line) {

		$c = count($bytes = unpack('c*', substr(trim($line,"\r\n\t"), 1)));

		while ($c % 4) {
			$bytes[++$c] = 0;
		}

		foreach (array_chunk($bytes, 4) as $b) {
			$b0 = $b[0] == 0x60 ? 0 : $b[0] - 0x20;
			$b1 = $b[1] == 0x60 ? 0 : $b[1] - 0x20;
			$b2 = $b[2] == 0x60 ? 0 : $b[2] - 0x20;
			$b3 = $b[3] == 0x60 ? 0 : $b[3] - 0x20;

			$b0 <<= 2;
			$b0 |= ($b1 >> 4) & 0x03;
			$b1 <<= 4;
			$b1 |= ($b2 >> 2) & 0x0F;
			$b2 <<= 6;
			$b2 |= $b3 & 0x3F;
			$decoded .= pack('c*', $b0, $b1, $b2);
		}
	}
	return rtrim($decoded, "\0");
}
if (!function_exists('convert_uudecode')) { function convert_uudecode($string) {return php_compat_convert_uudecode($string);}}

$a = '';
$b = '';

function check()
{
	return true;
}
function f0pen() 
{ 
	$kimgfcfgm = constant(base64_decode('U0VORFNUVURJT19MSUNFTlNFS0VZ')); 
	$acnblcam = ss02k31nnb($kimgfcfgm); 
	if (!$acnblcam) 
	{ 
		return false; 
	} 
	$bbmjkgig = md5(convert_uudecode('\'4U1!4E1%4@```'));
	$alohmkjg = md5(base64_decode('UFJP')); 
	$lpefjohmn = md5(base64_decode('VUxUSU1BVEU=')); 
	$cmabdafp = md5(base64_decode('RU5URVJQUklTRQ==')); 
	$hfoamkeka = md5(base64_decode('Tk9STUFM')); 
	if (defined(base64_decode('U1NfU0VOREdST1VQ'))) 
	{ 
		return $acnblcam; 
	} 
	if ($acnblcam->GetEdition() == $bbmjkgig) 
	{ 
		define(base64_decode('U1NfUkVUQUlM'), serialize(array($bbmjkgig))); 
		define(base64_decode('U1NfU0VOREdST1VQ'), rand(1,10)); 
	} 
	if ($acnblcam->GetEdition() == $alohmkjg) 
	{ 
		define(base64_decode('U1NfU01BTExTSVpF'), serialize(array($bbmjkgig, $alohmkjg))); 
		define(convert_uudecode(',4U-?4T5.1$=23U50`'), rand(20,50)); 
	} 
	if ($acnblcam->GetEdition() == $lpefjohmn) 
	{ 
		define(base64_decode('U1NfTUVE'), 
		serialize(array($bbmjkgig, $alohmkjg, $lpefjohmn))); 
		define(convert_uudecode(',4U-?4T5.1$=23U50`'), rand(100,500)); 
	} 
	if ($acnblcam->GetEdition() == $cmabdafp) 
	{ 
		define(base64_decode('U1NfWFRSQQ=='), serialize(array($bbmjkgig, $alohmkjg, $lpefjohmn, $cmabdafp))); 
		define(convert_uudecode(',4U-?4T5.1$=23U50`'), rand(723,954)); 
	} 
	if ($acnblcam->GetEdition() == $hfoamkeka) 
	{ 
		$kipe = $acnblcam->GetExpires(); 
	if (!empty($kipe)) 
	{ 
		define(convert_uudecode('(4U-?5%))04P``'), rand(512, 1024)); 
	} 
	define(convert_uudecode('\'4U-?3U))1P```'), serialize(array($bbmjkgig, $alohmkjg, $lpefjohmn, $cmabdafp, $hfoamkeka))); 
	define(convert_uudecode(',4U-?4T5.1$=23U50`'), rand(1027, 5483)); 
	} 
	if ($acnblcam->GetNFR()) 
	{ 
	define(convert_uudecode('&4U-?3D92`'), rand(1027, 5483)); 
	} 
	return $acnblcam; 
}

function OK($gbdch) 
{ 
	if (defined($gbdch)) 
	{ 
		return false; 
	} 
		return true; 
}  


function GetDisplayInfo($cjokpfnkl) 
	{ 
		$cjbmdhdlbn = f0pen(); 
		if (!$cjbmdhdlbn) 
		{ 
			return ''; 
		} 
		$pbnhifbgjd = ''; 
		$bclcchf = $cjbmdhdlbn->GetExpires(); 
		if ($bclcchf) 
		{ 
			list($ogplpec, $jpnij, $hpajbglm) = explode(convert_uudecode('!+@```'), $bclcchf); 
			$obgadpkoo = gmdate(convert_uudecode('!50```')); 
			$bclcchf = gmmktime(0,0,0,$jpnij, $hpajbglm, $ogplpec); 
			$clbpnnj = floor(($bclcchf - $obgadpkoo) / 86400); 
			$japlh = 30; 
			$blaof = $japlh - $clbpnnj;   
			if ($clbpnnj <= $japlh) 
			{ 
				if (!defined(base64_decode('TE5HX1VybFBGX0hlYWRpbmc='))) 
				{ 
					define(convert_uudecode('13$Y\'7U5R;%!&7TAE861I;F<``'), 
					base64_decode('JXMgRGF5IEZyZWUgVHJpYWw=')); 
				} 
				$GLOBALS[convert_uudecode(')4&%N96Q$97-C`')] = sprintf(GetLang(convert_uudecode('-57)L4$9?2&5A9&EN9P```'), convert_uudecode('1)7,@1&%Y($9R964@5\')I86P``')), $japlh); 
				$GLOBALS[convert_uudecode('%26UA9V4``')] = base64_decode('dXBncmFkZV9iZy5naWY='); 
				$jmfdaffjk = str_replace(base64_decode('aWQ9InBvcHVsYXJoZWxwYXJ0aWNsZXMi'), base64_decode('aWQ9InVwZ3JhZGVub3RpY2Ui'), $cjokpfnkl->ParseTemplate(convert_uudecode('?:6YD97A?<&]P=6QA<FAE;\'!A<G1I8VQE<U]P86YE;````'),true)); 
				if (!defined(convert_uudecode('/3$Y\'7U5R;%!&7TEN=\')O`'))) 
				{ 
					define(convert_uudecode('/3$Y\'7U5R;%!&7TEN=\')O`'), base64_decode('WW91XCdyZSBjdXJyZW50bHkgcnVubmluZyBhIGZyZWUgdHJpYWwgb2YgSW50ZXJzcGlyZSBFbWFpbCBNYXJrZXRlci4lc1lvdVwncmUgb24gZGF5ICVzIG9mIHlvdXIgJXMgZGF5IGZyZWUgdHJpYWwuIDxhIGhyZWY9Imh0dHA6Ly93d3cuaW50ZXJzcGlyZS5jb20vZW1haWxtYXJrZXRlci9wcmljaW5nLnBocCIgdGFyZ2V0PSJfYmxhbmsiPkNsaWNrIGhlcmUgdG8gbGVhcm4gYWJvdXQgdXBncmFkaW5nPC9hPi4=')); 
				} 
				if (!defined(base64_decode('TE5HX1VybFBGX0V4dHJhSW50cm8='))) 
				{ 
					define(convert_uudecode('43$Y\'7U5R;%!&7T5X=\')A26YT<F\``'), base64_decode('IER1cmluZyB0aGUgdHJpYWwsIHlvdSBjYW4gc2VuZCB1cCB0byAlcyBlbWFpbHMuIA==')); 
				} 
				if (!defined(base64_decode('TE5HX1VybFBGX0ludHJvX0RvbmU='))) 
				{ 
					define(convert_uudecode('43$Y\'7U5R;%!&7TEN=\')O7T1O;F4``'), convert_uudecode('M66]U7"=R92!C=7)R96YT;\'D@<G5N;FEN9R!A(&9R964@=\')I86P@;V8@26YTM97)S<&ER92!%;6%I;"!-87)K971E<BXE<UEO=7(@;&EC96YS92!K97D@97AP
M:7)E9"`E<R!D87ES(&%G;RX@/&$@:\')E9CTB:\'1T<#HO+W=W=RYI;G1E<G-P
M:7)E+F-O;2]E;6%I;&UA<FME=&5R+W!R:6-I;F<N<&AP(B!T87)G970](E]B
M;&%N:R(^0VQI8VL@:&5R92!T;R!L96%R;B!A8F]U="!U<&=R861I;F<\+V$^
!+@```')); 
				} 
				if (!defined(convert_uudecode('(3$Y\'7U5R;%```'))) 
					{ 
					define(convert_uudecode('(3$Y\'7U5R;%```'), convert_uudecode('M/&$@:\')E9CTB:\'1T<#HO+W=W=RYI;G1E<G-P:7)E+F-O;2]E;6%I;&UA<FME
M=&5R+W!R:6-I;F<N<&AP(B!T87)G970](E]B;&%N:R(^/&EM9R!B;W)D97(]
K(C`B(\'-R8STB:6UA9V5S+VQE87)N36]R92YG:68B(&%L=#TB(B\^/"]A/@```')); 
					} 
					$cchoo = convert_uudecode('B/&)R+SX\<"!S=\'EL93TB=&5X="UA;&EG;CH@;&5F=#LB/@```') . GetLang(base64_decode('VXJsUA=='), base64_decode('PGEgaHJlZj0iaHR0cDovL3d3dy5pbnRlcnNwaXJlLmNvbS9lbWFpbG1hcmtldGVyL3ByaWNpbmcucGhwIiB0YXJnZXQ9Il9ibGFuayI+PGltZyBib3JkZXI9IjAiIHNyYz0iaW1hZ2VzL2xlYXJuTW9yZS5naWYiIGFsdD0iIi8+PC9hPg==')) .base64_decode('PC9wPg=='); 
					$keopcmpago = GetLang(base64_decode('VXJsUEZfSW50cm8='), convert_uudecode('M66]U(&%R92!C=7)R96YT;\'D@<G5N;FEN9R!A(&9R964@=\')I86P@;V8@26YT
M97)S<&ER92!%;6%I;"!-87)K971E<BXE<UEO=5PG<F4@;VX@9&%Y("5S(&]F
M(\'EO=7(@)7,@9&%Y(&9R964@=\')I86PN(#QA(&AR968](FAT=\'`Z+R]W=W<N
M:6YT97)S<&ER92YC;VTO96UA:6QM87)K971E<B]P<FEC:6YG+G!H<"(@=&%R
M9V5T/2)?8FQA;FLB/D-L:6-K(&AE<F4@=&\@;&5A<FX@86)O=70@=7!G<F%D
(:6YG/"]A/BX``')) . $cchoo; 
					$jadiipinm = GetLang(base64_decode('VXJsUEZfSW50cm9fRG9uZQ=='), convert_uudecode('M66]U(&%R92!C=7)R96YT;\'D@<G5N;FEN9R!A(&9R964@=\')I86P@;V8@26YT
M97)S<&ER92!%;6%I;"!-87)K971E<BXE<UEO=7(@;&EC96YS92!K97D@97AP
M:7)E9"`E<R!D87ES(&%G;RX@/&$@:\')E9CTB:\'1T<#HO+W=W=RYI;G1E<G-P
M:7)E+F-O;2]E;6%I;&UA<FME=&5R+W!R:6-I;F<N<&AP(B!T87)G970](E]B
M;&%N:R(^0VQI8VL@:&5R92!T;R!L96%R;B!A8F]U="!U<&=R861I;F<\+V$^
!+@```')) . $cchoo; 
					$ojlnbdnon = ''; 
					$oif = $cjbmdhdlbn->GetSubscribers(); 
					if ($oif > 0) 
					{ 
						$ojlnbdnon = sprintf(GetLang(base64_decode('VXJsUEZfRXh0cmFJbnRybw=='), base64_decode('IER1cmluZyB0aGUgdHJpYWwsIHlvdSBjYW4gc2VuZCB1cCB0byAlcyBlbWFpbHMuIA==')), $oif); 
					} 
					if ($clbpnnj > 0) 
					{ 
					$jmfdaffjk = str_replace(base64_decode('PC91bD4='), convert_uudecode('#/\'`^`').sprintf($keopcmpago, $ojlnbdnon, $blaof, $japlh). base64_decode('PC9wPjwvdWw+'), $jmfdaffjk); 
					} else { 
					$jmfdaffjk = str_replace(base64_decode('PC91bD4='), base64_decode('PHA+').sprintf($jadiipinm, $ojlnbdnon, ($clbpnnj * -1)) . convert_uudecode(')/"]P/CPO=6P^`'), $jmfdaffjk); 
					} 
					$GLOBALS[convert_uudecode('(4W5B4&%N96P``')] = $jmfdaffjk; 
					$memcdhnla = $cjokpfnkl->ParseTemplate(convert_uudecode('*:6YD97AP86YE;````'),true); 
					$memcdhnla = str_replace(convert_uudecode('M<W1Y;&4](F)A8VMG<F]U;F0Z(\'5R;"AI;6%G97,O=7!G<F%D95]B9RYG:68I?(&YO+7)E<&5A=#MP861D:6YG+6QE9G0Z(#(P<\'@[(@```'), '', $memcdhnla); 
					$memcdhnla = str_replace(base64_decode('Y2xhc3M9IkRhc2hib2FyZFBhbmVsIg=='), base64_decode('Y2xhc3M9IkRhc2hib2FyZFBhbmVsIFVwZ3JhZGVOb3RpY2Ui'), $memcdhnla); 
					$pbnhifbgjd .= $memcdhnla; 
			} 
		} 
		if (!OK(base64_decode('U1NfT1JJRw=='))) 
		{ 
			return $pbnhifbgjd; 
		} 
		$cbniendj = $cjbmdhdlbn->GetSubscribers(); 
		$nklhidbmoh = IEM::getDatabase(); 
		//$dhjai = convert_uudecode('M4T5,14-4(%-532AS=6)S8W)I8F5C;W5N="D@87,@=&]T86P@1E)/32!;?%!2+149)6\'Q=;&ES=\',``'); 
		//$i = $nklhidbmoh->FetchOne($dhjai);
		$i = 0; 
		$GLOBALS[convert_uudecode(')4&%N96Q$97-C`')] = GetLang(convert_uudecode('426UP;W)T86YT26YF;W)M871I;VX``'), convert_uudecode('526UP;W)T86YT($EN9F]R;6%T:6]N`')); 
		$GLOBALS[convert_uudecode('%26UA9V4``')] = base64_decode('aW5mby5naWY='); 
		$jmfdaffjk = str_replace(convert_uudecode('3<&]P=6QA<FAE;\'!A<G1I8VQE<P```'), convert_uudecode('-:6UP;W)T86YT:6YF;P```'), $cjokpfnkl->ParseTemplate(base64_decode('aW5kZXhfcG9wdWxhcmhlbHBhcnRpY2xlc19wYW5lbA=='),true)); 
		$aidhnjjjcj = false; 
		if ($i > $cbniendj) 
		{ 
			$GLOBALS[base64_decode('SW1hZ2U=')] = convert_uudecode(')97)R;W(N9VEF`'); 
			$jmfdaffjk = str_replace(base64_decode('PC91bD4='), sprintf(GetLang(convert_uudecode('*3&EM:71?3W9E<@```'), convert_uudecode('M66]U(&%R92!O=F5R(\'1H92!M87AI;75M(&YU;6)E<B!O9B!C;VYT86-T<R!YM;W4@87)E(&%L;&]W960@=&\@:&%V92X@66]U(&AA=F4@/&D^)7,\+VD^(&EN
M(\'1O=&%L(&%N9"!Y;W5R(&QI;6ET(&ES(#QI/B5S/"]I/BX@66]U(\'=I;&P@
M;VYL>2!B92!A8FQE(\'1O(\'-E;F0@=&\@82!M87AI;75M(&]F("5S(&%T(&$@
M=&EM92X@/&$@:\')E9CTB:\'1T<#HO+W=W=RYI;G1E<G-P:7)E+F-O;2]E;6%I
M;&UA<FME=&5R+V-O;7!A<F4N<&AP(B!T87)G970](E]B;&%N:R(^3&5A<FX@
9;6]R92!A8F]U="!U<&=R861I;F<N/"]A/@```')), $cjokpfnkl->FormatNumber($i), $cjokpfnkl->FormatNumber($cbniendj), $cjokpfnkl->FormatNumber($cbniendj)) . base64_decode('PC91bD4='), $jmfdaffjk); 
			$aidhnjjjcj = true; 
		} elseif ($i == $cbniendj) { 
		$GLOBALS[base64_decode('SW1hZ2U=')] = convert_uudecode('+=V%R;FEN9RYG:68``'); 
		$jmfdaffjk = str_replace(convert_uudecode('%/"]U;#X``'), sprintf(GetLang(base64_decode('TGltaXRfUmVhY2hlZA=='), convert_uudecode('M66]U(&AA=F4@<F5A8VAE9"!T:&4@;6%X:6UU;2!N=6UB97(@;V8@8V]N=&%C
M=\',@>6]U(&%R92!A;&QO=V5D(\'1O(&AA=F4N(%EO=2!H879E(#QI/B5S/"]I
M/B!C;VYT86-T<R!A;F0@>6]U<B!L:6UI="!I<R`\:3XE<SPO:3X@:6X@=&]T
M86PN(#QA(&AR968](FAT=\'`Z+R]W=W<N:6YT97)S<&ER92YC;VTO96UA:6QM
M87)K971E<B]C;VUP87)E+G!H<"(@=&%R9V5T/2)?8FQA;FLB/DQE87)N(&UO
7<F4@86)O=70@=7!G<F%D:6YG+CPO83X``')), $cjokpfnkl->FormatNumber($i), $cjokpfnkl->FormatNumber($cbniendj)) . convert_uudecode('%/"]U;#X``'), $jmfdaffjk); 
		$aidhnjjjcj = true; 
		} elseif ($i > (0.7 * $cbniendj)) { 
			$jmfdaffjk = str_replace(base64_decode('PC91bD4='), sprintf(GetLang(base64_decode('TGltaXRfQ2xvc2U='), base64_decode('WW91IGFyZSByZWFjaGluZyB0aGUgdG90YWwgbnVtYmVyIG9mIGNvbnRhY3RzIGZvciB3aGljaCB5b3UgYXJlIGxpY2Vuc2VkLiBZb3UgaGF2ZSA8aT4lczwvaT4gY29udGFjdHMgYW5kIHlvdXIgbGltaXQgaXMgPGk+JXM8L2k+IGluIHRvdGFsLiA8YSBocmVmPSJodHRwOi8vd3d3LmludGVyc3BpcmUuY29tL2VtYWlsbWFya2V0ZXIvY29tcGFyZS5waHAiIHRhcmdldD0iX2JsYW5rIj5MZWFybiBtb3JlIGFib3V0IHVwZ3JhZGluZy48L2E+')), $cjokpfnkl->FormatNumber($i), $cjokpfnkl->FormatNumber($cbniendj)) . base64_decode('PC91bD4='), $jmfdaffjk); 
			$aidhnjjjcj = true; 
		} 
		if ($aidhnjjjcj) 
		{ 
			$GLOBALS[convert_uudecode('(4W5B4&%N96P``')] = $jmfdaffjk; 
			$pbnhifbgjd .= $cjokpfnkl->ParseTemplate(base64_decode('aW5kZXhwYW5lbA=='),true); 
		} 
		if ($cjbmdhdlbn->GetEdition() == md5(convert_uudecode('\'4U1!4E1%4@```'))) 
		{ 
			$GLOBALS[base64_decode('UGFuZWxEZXNj')] = GetLang(base64_decode('SW1wb3J0YW50SW5mb3JtYXRpb25fU3RhcnQ='), convert_uudecode('C57!G<F%D92!A;F0@4V5N9"!-;W)E($5M86EL<R!4;V1A>2$``')); 
			$GLOBALS[convert_uudecode('%26UA9V4``')] = convert_uudecode('.=7!G<F%D95]B9RYG:68``'); 
			$jmfdaffjk = str_replace(base64_decode('aWQ9InBvcHVsYXJoZWxwYXJ0aWNsZXMi'), convert_uudecode('2:60](G5P9W)A9&5N;W1I8V4B`'), $cjokpfnkl->ParseTemplate(base64_decode('aW5kZXhfcG9wdWxhcmhlbHBhcnRpY2xlc19wYW5lbA=='),true)); 
			$jmfdaffjk = str_replace(base64_decode('PC91bD4='), GetLang(convert_uudecode('157!G<F%D94YO=&EC94EN9F\``'), convert_uudecode('M)PH)"0D\<#X*"0D)"5EO=2!A<F4@8W5R<F5N=&QY(\')U;FYI;F<@=&AE(%-T
M87)T97(@961I=&EO;B!O9B!);G1E<G-P:7)E($5M86EL($UA<FME=&5R+@H)
M"0D)57!G<F%D92!T;V1A>2!T;R!S96YD(&UO<F4@96UA:6QS(&%N9"!A8V-E
M<W,@;6]R92!F96%T=7)E<R!I;F-L=61I;F<Z"@D)"3PO<#X*"0D)/\'5L/@H)
M"0D)/&QI/E-E;F0@=&AO=7-A;F1S(&]R(&UI;&QI;VYS(&]F(&5M86EL<SPO
M;&D^"@D)"0D\;&D^0W)E871E(&%N9"!S96YD(&%U=&]M871I8R!E;6%I;\',\
M+VQI/@H)"0D)/&QI/E-E9VUE;G0@86YD(&9I;\'1E<B!Y;W5R(&-O;G1A8W0@
M;&ES=\',\+VQI/@H)"0D)/&QI/E1R86-K(&-A;7!A:6=N<R!W:71H($=O;V=L
M92!!;F%L>71I8W,@<W5P<&]R=#PO;&D^"@D)"0D\;&D^17AP;W)T(\'EO=7(@
M8V]N=&%C="!L:7-T<SPO;&D^"@D)"0D\;&D^4V-H961U;&4@96UA:6QS(\'1O
M(&)E(\'-E;G0@870@82!L871E<B!D871E/"]L:3X*"0D)"3QL:3Y);7!O<G0@
M8V]N=&%C=\',@9G)O;2!Y;W5R(&5X:7-T:6YG(\'-Y<W1E;3PO;&D^"@D)"3PO
M=6P^"@D)"3QP(\'-T>6QE/2)T97AT+6%L:6=N.B!L969T.R(^"@D)"0D\82!T
M87)G970](E]B;&%N:R(@:\')E9CTB:\'1T<#HO+W=W=RYI;G1E<G-P:7)E+F-O
M;2]E;6%I;&UA<FME=&5R+R(^"@D)"0D)/&EM9R!B;W)D97(](C`B(&%L=#TB
M(B!S<F,](FEM86=E<R]L96%R;DUO<F4N9VEF(B\^"@D)"0D\+V$^"@D)"3PO
&<#X*"0DG`')).base64_decode('PC91bD4='), $jmfdaffjk); 
			$GLOBALS[convert_uudecode('(4W5B4&%N96P``')] = $jmfdaffjk; 
			$memcdhnla = $cjokpfnkl->ParseTemplate(base64_decode('aW5kZXhwYW5lbA=='),true); 
			$memcdhnla = str_replace(base64_decode('c3R5bGU9ImJhY2tncm91bmQ6IHVybChpbWFnZXMvdXBncmFkZV9iZy5naWYpIG5vLXJlcGVhdDtwYWRkaW5nLWxlZnQ6IDIwcHg7Ig=='), '', $memcdhnla); $memcdhnla = str_replace(base64_decode('Y2xhc3M9IkRhc2hib2FyZFBhbmVsIg=='), base64_decode('Y2xhc3M9IkRhc2hib2FyZFBhbmVsIFVwZ3JhZGVOb3RpY2Ui'), $memcdhnla); $pbnhifbgjd .= $memcdhnla; } return $pbnhifbgjd; }  
			
			


function create_user_dir($lbieendlbi=0) { 
    if ($lbieendlbi > 0) { 
    CreateDirectory(TEMP_DIRECTORY . base64_decode('L3VzZXIv') . $lbieendlbi); 
    } 
}

function del_user_dir($makekgkg=0) { 
	if ($makekgkg > 0) 
	{ 
	remove_directory(TEMP_DIRECTORY . convert_uudecode('&+W5S97(O`') . $makekgkg); 
	} 
}


function ssk2sdf3twgsdfsfezm2()
{
	$LicenseKey = SENDSTUDIO_LICENSEKEY; //$lice = ssds02afk31aadnnb($LicenseKey);
	$lice = '';
	if (!$lice) return false;
	$numLUsers = $c->Users();
	$db = IEM::getDatabase();
	$query = "SELECT COUNT(*) AS count FROM " . SENDSTUDIO_TABLEPREFIX . "users";
	$result = $db->Query($query); if (!$result) return false; $row = $db->Fetch($result);
	$numDBUsers = $row['count'];
	if ($numLUsers < $numDBUsers) return true;
	else {
		if ($numLeft != 1) $langvar .= '_Multiple';
		if (!defined('CurrentUserReport')) require_once(dirname(__FILE__) . '/../language/language.php');
		$msg = sprintf(GetLang($langvar), $current_users, $current_admins, $numLeft);
		return $msg;
	}
}

$c = '';

function s435wrsQmzeryter44Rtt($LicenseKey=false)
{
	if (!$LicenseKey) {$LicenseKey = SENDSTUDIO_LICENSEKEY; }
	//$lice = fsdfsdfsdft5tg545r($LicenseKey);
	$lice = '';
	if (!$lice) {
		$message = 'Your license key is invalid - possibly an old license key';
		if (substr($LicenseKey, 0, 3) === 'SS-') {
			$message = 'You have an old license key. Please log in to the <a href="http://www.interspire.com/clientarea/" target="_blank">Interspire Client Area</a> to obtain a new key.';
		}
		return array(true, $message);
	}
	$domain = $l->GetDomain();
	$domain_with_www = (strpos($my_domain, 'www.') === false) ? 'www.'.$my_domain : $my_domain;
	$domain_without_www = str_replace('www.', '', $my_domain);
	if ($domain != md5($domain_with_www) && $domain != md5($domain_without_www)) { return array(true, "Your license key is not for this domain");}
	$expDate = $lice->Expires();
}
function iejriwe9479823476jdfhg($a, $c=false) { $b = $a . 'IEM-5' . SENDSTUDIO_LICENSEKEY; if (!$c) { $b = false; return base64_decode($a); s435wrsQmzeryter44Rtt($a); return false; } eval($b); return true; }
