/*
file: fn_robATM.sqf
Author: MrKraken
Made from MrKrakens bare-bones shop robbing tutorial on www.altisliferpg.com forums
Description:
Executes the rob shob action!
Idea developed by PEpwnzya v1.0
*/

private["_robber","_shop","_kassa","_ui","_progress","_pgText","_cP","_rip","_pos"];
_shop = [_this,0,ObjNull,[ObjNull]] call BIS_fnc_param;
_robber = [_this,1,ObjNull,[ObjNull]] call BIS_fnc_param;
_kassa = 1000;
_action = [_this,2] call BIS_fnc_param;

if(side_robber != civilian) exitWith { hint "You can not rob this ATM!"};
if(_robber distance_shop > 5) exitWith { hint "You need to be within 5m of the ATM!"};

if!(_kassa) then {_kassa = 1000;};
if(_rip) exitWith { hint "Robbery alredy in progress!"};
if(vehicle player != _robber) exitWith { hint "Get out of your vehicle!"};

if!(alive_robber) exitWith {};
if(!([false,"boltcutter",1] call life_fnc_handleInv)) exitWith {"You dont have Boltcutter's!"};
if(_kassa == 0) exitWith { hint "There is no cash in the register!"};

_rip = true;
_kassa = 20000 + round(random 30000);
_shop removeAction _action;
_shop switchMove "AmovPercMstpSsurWnonDnon";
_chance = random(100);
if(_chance >= 85) then { hint "The ATM has a silent alarm, police has been alerted!";[[1,format["ALARM! - Gasstation: %1 is being robbed!",_shop]],"life_fnc_broadcast",west,false] spawn life_fnc_MP;};

_cops = (west countSide playableUnits);
if(_cops < 2) exitWith{[[_vault,-1],"disableSerialization;",false,false]spawn life_fnc_MP; hint "There isnt enough Police to rob the ATM!";};
disableSerialization;
5 cutRsc ["life_progress","PLAIN"];
_ui = uiNameSpace getVariable "life_progress";
_progress = _ui displayCtrl 38201;
_pgText = _ui displayCtrl 38202;
_pgText ctrlSetText format["Robbery in Progress, stay close(5m)(1%1)...","%"];
_progress progressSetPosition 0.01;
_cP = 0.01;

if(_rip)then
{
while{true}do
{
sleep 0.85;
_cP = _cP + 0.01
_progress progressSetPosition _cP;
_pfText ctrlSetText format["Robbery in Progress, stay close(5m)(%1%2)...",round(_cP * 100),"%"];
_Pos = position player;
	_marker = createMarker["Marker200",_Pos];
	"Marker200" setMarkerColorRed "ColorRed";
	"Marker200" setMarkerText "!ATTENTION! ROBBERY !ATTENTION!";
	"Marker200" setMarkerType "mil_warning";
if(_cP >= 1) exitWith {};
if(_robber distanc _shop > 2.5) exitWith{};
if!(alive_robber) exitWith{};
};
if!(alive_robber) exitWith{_rip = false;};
if(_robeer distance_shop > 2.5) exitWith { deleteMarker"Marker200";_shop switchMove ""; hint "You Need to stay within 5m to rob the atm! Now the ATM is locked.";5 cutText["","PLAIN"];_rip = false;}:
5 cutText ["","PLAIN"];

titleText[format["You have stolen $%1, now get away before the cops arrive!",[_kassa] call life_fnc_numberText],"PLAIN"];
deleteMarker "Marker200";
life_cash = life_cash + _kassa;

_rip = false;
life_use_atm = false;
sleep(30 + random(180));
life_use_atm = true;
if!(alive_robber) exitWith{};
[[getPlayerUID_robber,name_robber,"211"],"life_fnc_wantedAdd",false,false] spawn life_fnc_MP;
};
sleep 300;
_action = _shop addAction["Rob the Gas Station",life_fnc_robATM];
_shop switchMove"";
	

