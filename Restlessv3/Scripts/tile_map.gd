extends TileMap



signal enable_player
signal disable_player

const MAXHEIGHT:int=80
const MAXWIDTH:int=80
const WALL:int=1
const EMPTY:int=0
const CELLSIZE:int=32
const ID:int=0
const PASSABLE:int=1
const INHABITANT:int=2

const enemy_resource:PackedScene=\
		preload("res://Enemy.tscn")
const PlayerUp:Texture=\
		preload("res://Sprites/PlaceHolder/Player_Up.png")
const PlayerDown:Texture=\
		preload("res://Sprites/PlaceHolder/Player_Down.png")
const PlayerRight:Texture=\
		preload("res://Sprites/PlaceHolder/Player_Right.png")
const PlayerLeft:Texture=\
		preload("res://Sprites/PlaceHolder/Player_Left.png")
const Directions:PoolVector2Array=PoolVector2Array([
	Vector2(0,-1),
	Vector2(0,1),
	Vector2(1,0),
	Vector2(-1,0),
	])

const MapDirections:Dictionary={
	KEY_KP_8:Vector2(0,-1),
	KEY_KP_2:Vector2(0,1),
	KEY_KP_4: Vector2(-1,0),
	KEY_KP_6: Vector2(1,0),
	}

const PlayerDirections:Dictionary={
	KEY_UP:Vector2(0,-1), KEY_DOWN:Vector2(0,1),
	KEY_LEFT: Vector2(-1,0), 
	KEY_RIGHT: Vector2(1,0),
	}
	
const SpriteDirections:Dictionary={
	KEY_UP:PlayerUp,
	KEY_DOWN:PlayerDown,
	KEY_LEFT: PlayerLeft, 
	KEY_RIGHT:PlayerRight 
	}
var player_control:bool=false setget set_control
var map_graph:AStar2D=AStar2D.new()
var map_info:Dictionary={}
#var CellId={}
#var Passable={}
#var Inhabitant={}
var event_stash:Array=[]
var PlayerNode:Character
var EnemyNode:Enemy
var CameraNode:Camera2D
var HpManager:HpContainer
#var MapDistances={}



func _ready()->void:
	
	PlayerNode=get_node("Player")
	EnemyNode=enemy_resource.instance()
	add_child(EnemyNode)
	CameraNode=get_node("Camera")
	EnemyNode.add_to_group("Enemies")
	generate_map(0.7,4)
	make_enemy(30)
	self.player_control=true 


func _input(event:InputEvent)->void:
	if not event.is_pressed():
		return
	
	if event is InputEventKey and event.is_pressed() and \
			(event.scancode==KEY_UP or event.scancode==KEY_DOWN or \
			event.scancode==KEY_RIGHT or event.scancode==KEY_LEFT):
		if player_control==true:
			player_move(event.scancode)
			get_tree().set_input_as_handled()
			self.player_control=false
			enemyturn()
		
	if event is InputEventKey and event.is_pressed() and \
			event.scancode==KEY_ESCAPE:
		get_tree().quit()
		
	if event is InputEventKey and event.is_pressed() and \
			event.is_action("map_move"):
		pan_map(event.scancode)



func set_control(var value:bool)->void:
	match value:
		true:
			player_control=true
			emit_signal("enable_player")
		false: 
			assert(player_control==true)
			player_control=false
			emit_signal("disable_player")
	pass
#func init_distances()->void:
#	for j in range(MaxHeight):
#		for i in range(MaxWidth):
#			MapDistances[Vector2(i,j)]=null
#	return
#
#func update_distances()->void:
#	var player_pos:Vector2=world_to_map(PlayerNode.position)
#	var visited={player_pos:true}
#	MapDistances[player_pos]=0
#	var arr1:PoolVector2Array=PoolVector2Array([])
#	var arr2:PoolVector2Array=PoolVector2Array([])
#	arr1.append(player_pos)
#	for r in range(10):
#		for v in arr1:
#			for d in Directions:
#				if not visited.has(v+d):
#					MapDistances[v+d]=MapDistances[v]+1
#					arr2.append(v+d)
#					visited[v+d]=true
#
#		arr1=arr2
#		arr2=PoolVector2Array([])
#	print(MapDistances[Vector2(0,0)])
#	print(MapDistances[Vector2(0,1)])





	
func pan_map(direction:int)->void:
	assert(MapDirections[direction]!=null)
	CameraNode.position=CameraNode.position+ \
	CELLSIZE*MapDirections[direction]
	#print(CameraNode.position)
	





#########################################
########################################
# Map Generation



func generate_map(maxratio:float,iterations:int)->void:
	#fill the map with walls
	for i in range(MAXWIDTH):
		for j in range(MAXHEIGHT):
			set_cell(i,j,WALL) 
			map_info[Vector2(i,j)]=[null,false,null]
	#Generate the binary tree
	var bintree=BTree.new(Vector2(0,0),Vector2(MAXWIDTH-1,MAXHEIGHT-1))
	randomize()
	bintree.birth(maxratio,iterations)
	#Debug
	#debug_tree(bintree)
	
	#Tunneling and room creation with player spawn 
	tunneling(bintree)
	room_creation(bintree,true)

func tunneling(bintree:BTree)->void:
	if bintree.child1==null or bintree.child2==null: return
	#Horizontal Tunnel
	#print(bintree.child1.pos_ul, bintree.child2.pos_ul, "\n")
	if bintree.child1.pos_ul.y==bintree.child2.pos_ul.y:
		#print("Horizontal")
# warning-ignore:integer_division
		var centerh:int=int(bintree.pos_dr.y+bintree.pos_ul.y)/2
# warning-ignore:integer_division
		var beggin:int=int(bintree.child1.pos_dr.x +bintree.child1.pos_ul.x)/2
# warning-ignore:integer_division
		var end:int=int(bintree.child2.pos_dr.x +bintree.child2.pos_ul.x)/2
		#print("Center: ", centerh)
		#print("Extremes: ", beggin, ",", end)
		for i in range(beggin,end+1):
			set_cell(i,centerh,EMPTY)
			add_cell_to_map(Vector2(i,centerh))
	#Vertical Tunnel
	if bintree.child1.pos_ul.x==bintree.child2.pos_ul.x:
		#print("Vertical")
# warning-ignore:integer_division
		var centerv:int=int(bintree.pos_dr.x+bintree.pos_ul.x)/2
		#print("Center: ", centerv)
# warning-ignore:integer_division
		var beggin:int=int(bintree.child1.pos_dr.y +bintree.child1.pos_ul.y)/2
# warning-ignore:integer_division
		var end:int=int(bintree.child2.pos_dr.y +bintree.child2.pos_ul.y)/2
		#print("Extremes: ", beggin, ",", end)
		for i in range(beggin,end+1):
			set_cell(centerv,i,EMPTY)
			add_cell_to_map(Vector2(centerv,i))
	tunneling(bintree.child1)
	tunneling(bintree.child2)

func room_creation(bintree:BTree,spawn:bool)->void:
	if (not bintree.child1==null) or (not bintree.child1==null):
		room_creation(bintree.child1,spawn)
		room_creation(bintree.child2,false)
		return
	var begin_h:int=int(bintree.pos_ul.x) + randi()%4
	var end_h:int=int(bintree.pos_dr.x)  - randi()%4
	var begin_v:int=int(bintree.pos_ul.y) + randi()%4
	var end_v:int=int(bintree.pos_dr.y)  - randi()%4
	if spawn==true:
		PlayerNode.position=CELLSIZE*Vector2(begin_h,begin_v)
		map_info[Vector2(begin_h,begin_v)][PASSABLE]=false
		map_info[Vector2(begin_h,begin_v)][INHABITANT]=PlayerNode
	for i in range (begin_h,end_h+1):
		for j in range (begin_v,end_v+1):
			set_cell(i,j,EMPTY)
			add_cell_to_map(Vector2(i,j))

func make_enemy(dist:int)->void:
	var playermappos:Vector2=world_to_map(PlayerNode.position)
	for j in range(dist):
		for i in range(dist-j):
			if get_cell(int(playermappos.x + i),
			int(playermappos.y + dist-j-i))==EMPTY:
				EnemyNode.position=CELLSIZE*Vector2(playermappos.x + i,playermappos.y + dist-j-i)
				map_info[Vector2(playermappos.x + i,playermappos.y + dist-j-i)][INHABITANT]=\
				EnemyNode
				map_info[Vector2(playermappos.x + i,playermappos.y + dist-j-i)][PASSABLE]=\
				false
				#print(Vector2(playermappos.x + i,playermappos.y + dist-j-i))
				return


func add_cell_to_map(pos:Vector2)->void:
	if  map_info[pos][ID]==null:
		var id:int=map_graph.get_available_point_id()
		map_graph.add_point(id,pos)
		map_info[pos][ID]=id
		map_info[pos][PASSABLE]=true
		for v in Directions:
			assert(v is Vector2)
			if map_info.has(pos+v) and\
			map_info[pos+v][ID]!=null and map_info[pos+v][PASSABLE]==true:
				map_graph.connect_points(id,map_info[pos+v][ID])

func disconnect_cell(pos:Vector2)->void:
	assert(map_info.has(pos) and map_info[pos][ID]!=null)
	map_info[pos][PASSABLE]=false
	var posId:int=map_info[pos][ID]
	for i in map_graph.get_point_connections(posId):
		map_graph.disconnect_points(posId,i)


class BTree:
	var child1:BTree=null
	var child2:BTree=null
	var enviroment_map:TileMap
	var pos_ul:Vector2
	var pos_dr:Vector2
	
	func _init(ul:Vector2, dr:Vector2):
		pos_ul=ul
		pos_dr=dr
		#print("ul: ",pos_ul)
		#print("dr: ",pos_dr,"\n")
		
		
		
	
	
	func birth(maxratio:float,iterations:int)->void:
		var hsize:int=int(pos_dr.x-pos_ul.x)
		var vsize:int=int(pos_dr.y-pos_ul.y)
		var dir:int=randi()%2
		var rat:float=float(vsize)/float(hsize)
		if  rat > 1.6:
			dir=0
		if 1/rat > 1.6:
			dir=1
		
		if dir==1: #Vertical division 
			var cut:int 
			var total:int=(int(pos_dr.x) - int(pos_ul.x))
			var valid:bool=false
			while valid==false:
				#compute cut point
				cut=randi()%total
				#check if cut point is valid
				var ratio:float=float(cut)/float(total)
				
				if ratio<=maxratio and 1-ratio <= maxratio:
					valid=true
				#print(cut,",",total)
			var cutpoint1:Vector2=Vector2(pos_ul.x+cut,pos_dr.y)
			var cutpoint2:Vector2=Vector2(pos_ul.x +cut +1, pos_ul.y)
			child1=BTree.new(pos_ul,cutpoint1)
			child2=BTree.new(cutpoint2,pos_dr)
			if iterations>1:
				child1.birth(maxratio,iterations-1)
				child2.birth(maxratio,iterations-1)
			
		if dir==0: #Horizontal division 
			var cut:int 
			var total:int=(int(pos_dr.y) - int(pos_ul.y))
			var valid:bool=false
			while valid==false:
				#compute cut point
				cut=randi()%total
				#check if cut point is valid
				var ratio:float=float(cut)/float(total)
				
				if ratio<=maxratio and 1-ratio <= maxratio:
					valid=true
				#print(cut,",",total)
			var cutpoint1:Vector2=Vector2(pos_dr.x,pos_ul.y+cut)
			var cutpoint2:Vector2=Vector2(pos_ul.x, pos_ul.y+cut+1)
			child1=BTree.new(pos_ul,cutpoint1)
			child2=BTree.new(cutpoint2,pos_dr)
			if iterations>1:
				child1.birth(maxratio,iterations-1)
				child2.birth(maxratio,iterations-1)
		return

#func debug_tree(bintree:BTree):
#	if (not bintree.child1==null) or (not bintree.child1==null):
#		debug_tree(bintree.child1)
#		debug_tree(bintree.child2)
#		return
#	var rect=ReferenceRect.new()
#	rect.editor_only=false
#	rect.rect_position=CELLSIZE*bintree.pos_ul
#	rect.rect_size=CELLSIZE*(bintree.pos_dr-bintree.pos_ul)
#	add_child(rect)

###################################################################
###################################################################



#GAME_MASTER


func game_loop()->void:
	
	pass

func enemyturn()->void:
	var CurrentEnemy:Enemy
	var has_anybody_acted:bool=true
	event_stash=[]
	for CurrentEnemy in get_tree().get_nodes_in_group("Enemies"):
		CurrentEnemy.add_to_group("ReadyEnemies")
	while has_anybody_acted==true:
		has_anybody_acted=false
		for CurrentEnemy in get_tree().get_nodes_in_group("ReadyEnemies"):
			if CurrentEnemy.take_turn(map_graph,map_info)==true:
				CurrentEnemy.remove_from_group("ReadyEnemies")
				has_anybody_acted=true
			while not event_stash.empty():
				request_action(event_stash.front())
				event_stash.pop_front()
		
	
	
	
	
	var playerid:int=map_info[world_to_map(PlayerNode.position)][ID]
	var enemyid:int=map_info[world_to_map(EnemyNode.position)][ID]
	var path=map_graph.get_id_path(enemyid,playerid)
	EnemyNode.mappos=map_graph.get_point_position(path[1])
	yield(get_tree(), "idle_frame")
	self.player_control=true
	return


func request_action(action:Array)->bool:
	var action_name:String=action[0]
	var action_args:Array=action[1]
	return callv(action_name,action_args)




func ATTACK_(attacker:Character,\
 var attacked:Character, amount:int)->bool:
	attacked.current_hp-=amount
	return true
	

func MOVE_( actor:Character, destination:Vector2,\
var blink:bool=false)->bool:
	return true


func player_move(direction:int)->void:
	assert(PlayerDirections[direction]!=null)
	var pos:Vector2= PlayerNode.position + CELLSIZE*PlayerDirections[direction]
	var mappos:Vector2=world_to_map(pos)
	if get_cell(int(mappos.x),int(mappos.y))==EMPTY and\
	EnemyNode.position!=pos:
		PlayerNode.position=pos
		PlayerNode.texture=SpriteDirections[direction]


func start_turn_animations()->void:
	pass





	
	
	
	
	
