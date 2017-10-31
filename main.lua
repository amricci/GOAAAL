-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- soccer app
--
-----------------------------------------------------------------------------------------

--Hide Status Bar
display.setStatusBar(display.HiddenStatusBar)

--load widget library
local widget = require("widget")

--load the physics library
local physics = require("physics")
physics.start() --start the physics engine MUST DO THIS!!!

-- 1. Enable drawing mode for testing, you can use "normal", "debug" or "hybrid"
physics.setDrawMode("hybrid")

--Set Gravity
physics.setGravity(0, 0)

--Set Background
local background = display.newImage("images/grass.png", display.contentCenterX, display.contentCenterY)
background:scale(.75,.75)

--set flags
local usaFlag = display.newImage("images/americanFlag.png", display.contentCenterX+300, display.actualContentHeight-170)
usaFlag:scale(.25,.25)

local brazilFlag = display.newImage("images/brazil.png", display.contentCenterX-250, 170)
brazilFlag:scale(.3,.3)

--set score indicators
local usaScore = 0
local brazilScore = 0

local tag = "Score = "

local brazilScoreTag = display.newText(tag, display.contentCenterX - 250, 300, native.systemFont, 30)
local usaScoreTag = display.newText(tag, display.contentCenterX + 250, display.actualContentHeight - 50, native.systemFont, 30)

--set win Tag
local winTag = display.newText("", display.contentCenterX, display.contentCenterY, native.systemFont, 50)

--set goals
local topGoal = display.newImage("images/Goal_Top.png", display.contentCenterX-5, 50)
topGoal:scale(.75,.75)
physics.addBody(topGoal, "static", {bounce = .1})
topGoal.myName = "topGoal"

local botGoal = display.newImage("images/Goal_Bottom.png", display.contentCenterX-5, 1400)
botGoal:scale(.77,.75)
physics.addBody(botGoal, "static", {bounce = .1})
botGoal.myName = "botGoal"

--Create global screen boundaries
local leftWall = display.newRect(-5, display.contentCenterY, 10, display.actualContentHeight)
physics.addBody (leftWall, "static", { bounce = 0.1} )

local rightWall = display.newRect(display.actualContentWidth+5, display.contentCenterY, 10, display.actualContentHeight)
physics.addBody (rightWall, "static", { bounce = 0.1} )

local topWall = display.newRect(display.contentCenterX, -5, display.actualContentWidth, 10)
physics.addBody (topWall, "static", { bounce = 0.1} )

local botWall = display.newRect(display.contentCenterX, display.actualContentHeight+5, display.contentWidth, 10)
physics.addBody(botWall, "static", {bounce = 0.1})

--create ball
local ball = display.newImage("images/soccerBall.png", display.contentCenterX, display.contentCenterY)
ball:scale(.2,.2)
physics.addBody(ball, "dynamic", {bounce =.2, radius = 67})
ball.myName ="ball"

----------------------------------------------
---------------Functions----------------------
----------------------------------------------

--function called when an object is touched
function onTouch(event)
	if (event.phase == "began") then
		--if the touch has just started then create the touch joint
		--at the coordinates of the users finger
		touchJoint = physics.newJoint("touch", ball, event.x, event.y)
		return true

	elseif (event.phase == "moved") then
		--if the object is moved, set the coordinates accordingly
		touchJoint:setTarget(event.x, event.y)
		return true

	elseif (event.phase == "ended" or event.phase == "submitted") then
		touchJoint:removeSelf()
		touchJoint = nil
		return true

	end
end


function onHit(event)
	if (event.phase == "began") then
		if (event.object1.myName == "topGoal" and event.object2.myName == "ball") then
			print("Collision detected.")
			usaScore = usaScore + 1
			usaScoreTag.text = tag .. usaScore
			if (usaScore == 3) then 
				winEventUsa()
			end


		elseif (event.object1.myName == "botGoal" and event.object2.myName == "ball") then
			print("Collision detected.")
			brazilScore = brazilScore + 1
			brazilScoreTag.text = tag .. brazilScore
			if (brazilScore == 3) then
				winEventBrazil()
			end


		end

	elseif (event.phase == "ended" or event.phase == "submitted") then
		
	end
end

-- Function to handle button events
local function handleButtonEvent( event )
 
    if ( "ended" == event.phase ) then
        print( "Button was pressed and released" )
        reset()
    end
end


--on win reset all values and display winner
function winEventBrazil()
	usaScoreTag.text = tag
	brazilScoreTag.text = tag
	winTag.text = "Brazil wins!"
	-- Create the widget
	local button1 = widget.newButton(
	    {
	        left = 75,
	        top = 300,
	        id = "button1",
	        label = "Add Values",
	        onEvent = handleButtonEvent
	    }
	)



end

function winEventUsa()
	usaScoreTag.text = tag
	brazilScoreTag.text = tag
	winTag.text = "USA wins!"
	-- Create the widget
	local button1 = widget.newButton(
	    {
	        left = 75,
	        top = 300,
	        id = "button1",
	        label = "Reset",
	        onEvent = handleButtonEvent
	    }
)


end


function reset()
	physics.pause
	usaScore = 0
	brazilScore = 0
	winTag.text = ""
	ball.x = display.contentCenterX
	ball.y = display.contentCenterY
	button1.isVisible = false
	physics.start


end


--------------------------------------
-----------Listeners------------------
--------------------------------------

Runtime:addEventListener("touch", onTouch)
Runtime:addEventListener("collision", onHit)