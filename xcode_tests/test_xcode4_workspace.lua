--
-- tests/actions/xcode/xcode4_workspace.lua
-- Copyright (c) 2013 Jason Perkins and the Premake project
--	
	local suite = test.declare("xcode4_workspace") 
	local xcode4 = premake.xcode4 
--
-- Setup
-- 
	local prj
	function suite.teardown()
		prj = nil
	end
		
	function suite.setup()
		_ACTION = "xcode4"
		local sln
		sln, prj = test.createsolution() 						
	end
	
	local function prepare()		
		premake.solution.bakeall()
		local sln = premake.solution.get(1)		
	    premake.xcode.preparesolution(sln)	
		prj = premake.solution.getproject(sln, 1)     
	    xcode4.workspace_file_ref(prj)
	end
 
	function suite.xmlDeclarationPresent()		
		xcode4.workspace_head()
		xcode4.workspace_tail()
		test.capture [[
<?xml version="1.0" encoding="UTF-8"?>
<Workspace
	version = "1.0">
</Workspace>
	]] 		
	end
		
	function suite.workspace_addsProjectInFileRefTags()
	    prepare()
	    test.capture [[
	<FileRef
		location = "group:MyProject.xcodeproj">
	</FileRef>
		]]
	end
		
	function suite.pathPrefixAndProjectName_pathIsPathIsDifferentDir_pathPostfixSlashAdded()
		prj.location = "foo"
		prepare()
	   test.capture [[
	<FileRef
		location = "group:foo/MyProject.xcodeproj">
	</FileRef>
		]]		
	end