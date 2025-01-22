set GameToolkitPath=..\..\..\..\PironGames-GameToolkit-Win32-1.0.0
set GameLib2Path=..\..\..
set ProjectPath=..

@rem Make the language data library
perl.exe "%GameLib2Path%\tools\makelanglib.pl" "%GameToolkitPath%\StringTool.exe" "%GameLib2Path%\tools\StringTool\StringScript_HxGameLib2.csl" ".\strings" ".\strings\langlib"

cp -f "strings\EN_US\AllStrings.hx" "%ProjectPath%\src\data"
@rem cp -f "strings\EN\StringPackages.hx" "..\src\data"

@echo Building the Sprite Library
perl.exe "%GameLib2Path%\tools\makedatalib.pl" "sprites" "sprites\sprlib" "%ProjectPath%\src\data\SprId.hx" bin SprId SPR

@rem "..\..\..\..\PironGames-GameToolkit-Win32-1.0.0\StringTool.exe" -input ".\strings\Strings_EN.xml" -script "..\..\..\tools\StringTool\StringScript_AS30_ByteArray_Lang.csl" -output ".\strings\EN"

