rollout roll_expmesh "Export Mesh" width:162 height:346
(
	edittext edt_path "Path" pos:[10,10] width:300 height:17 

	button btn_Browse "Browse" pos:[320,10] width:50 height:21  

	button btn_exp "Export" pos:[58,36] width:46 height:21         
    
	checkbox chk_v "Vertex" pos:[13,62] width:54 height:15 checked:true  
  
  
  
  
	checkbox chk_n "Normal" pos:[13,82] width:57 height:15 checked:true
	checkbox chk_f "Face" pos:[13,102] width:48 height:15 checked:true
	checkbox chk_t "Texture" pos:[13,122] width:60 height:15 checked:true
	checkbox DepthBuff "DepthBuffered" pos:[13,144] width:97 height:14 checked:true
	checkbox DepthBs "DepthBias" pos:[14,165] width:93 height:15 checked:false
	checkbox OneSide "One Sided" pos:[14,183] width:93 height:16 checked:true
	--bitmap GO "GO" pos:[9,220] width:140 height:116 fileName:"GO.png" bitmap:GO
      
	on roll_expmesh open do
	(
	 
	
	  s=selection[1].name as string
	  edt_path.text=(GetDir #Export)+"\\"+s+".msh"
	)
	on btn_Browse pressed do
	(
	  
	  s=GetSaveFileName types:"Mesh file (*.msh)|*.msh|All files (*.*)|*.*"
	  if s!=undefined do
	  (
	    edt_path.text=s
	  )
	)
	on btn_exp pressed do
	(
	  
	  local bV=0      
	  local bN=0      
	  local bF=0      
	  local bT=0      
	  
	  
	  if chk_v.checked==true then bV=1
	  if chk_n.checked==true then bN=1
	  if chk_f.checked==true then bF=1
	  if chk_t.checked==true then bT=1
	  
	    
	    if edt_path.text!=undefined do
	    (
	      
	      file01=createFile edt_path.text
	
	     -- format "% " bV to:file01
	     -- format "% " bN to:file01
	     -- format "% " bF to:file01
	     -- format "%\n" bT to:file01
	  
	      local vnum=getNumVerts selection[1].mesh
	
	      local fnum=getNumFaces selection[1].mesh
	
	      local tnum=getNumTVerts selection[1].mesh
	
	      format "% " vnum to:file01
	      format "% " fnum to:file01
	      format "%\n" tnum to:file01
	      
	      mesh01=snapshotasmesh selection[1]
		
		--local Opty = meditMaterials[1].opacity as integer
		--format "%\n" Opty to:file01
		
		myMat = selection[1].mat
	      matName = myMat.name
		matOpacity = myMat.opacity
		opcty = matOpacity as string
		format "Opacity = " to:file01
		format opcty to:file01
	
	      local found = 0
	      local objMat = selection[1].mat			
		for i = 1 to meditMaterials.count where found == 0 do
	      if meditMaterials[i] == objmat then found = i
	      found -- contains the index of the material slot, or 0 if it was not found
		
		--local Mnames = GetMeditMaterial found as string
--		for Mname=1 to found do
--		(
--			Mnames = GetMeditMaterial Mname as string
--			--format "%" Opty to:file01
--			format "\n" to:file01
--			format Mnames to:file01
--			format "\n" to:file01
--		)
	
		--local M = --get num of material--
	
		format "[Material]\n" to:file01
		format "{\n" to:file01
		format "  NumOfM = " to:file01
	      format "%\n" found to:file01
	      format "  [SortOrder]\n" to:file01
	      format "  {\n" to:file01
		
		for m=1 to found do
		(
			mm=(m-1) as integer
			format "    M" to:file01
			format "%" mm to:file01
			format " = " to:file01
			format "%\n" mm to:file01
			
		)
	      format "  }\n" to:file01
		for z=1 to found do
		(
			zz=(z-1) as integer
			Mnamess = GetMeditMaterial z as string
		format "  [M" to:file01
		format "%" zz to:file01
		format "]\n" to:file01
		format "  {\n" to:file01
		format "   Name = " to:file01
		format "\"" to:file01
		format Mnamess to:file01
		format "\"" to:file01	
		format "\n" to:file01
		format "  }\n" to:file01		
		)
		--format "}\n" to:file01
	      if chk_v.checked==true do
	      (
	        --vnum=getNumVerts selection[1].mesh as string
	        local vnumb=getNumVerts selection[1].mesh				
	        format "[Vertex] \n"  to:file01
		  format "{ \n" to:file01
		  format "  NumOfV = " to:file01
	        format "%\n" vnumb to:file01	--number of vertices WIP			
	        for j=1 to vnum do
	        (
	          local p01=[0,0,0] --vertex coords
	          p01=GetVert mesh01 j
				jj=(j-1) as integer
			format "  V" to:file01 --vertex number WIP
			format "%" jj to:file01
			format " = " to:file01
			vertex1 = formattedPrint p01.x format:"0 g"
			vertex2 = formattedPrint p01.y format:"0 g"
			vertex3 = formattedPrint p01.z format:"0 g"
			format "%, " vertex1 to:file01
			format "%, " vertex2 to:file01
			format "%\n" vertex3 to:file01
--	          formattedPrint "%, " p01.x to:file01
--	          formattedPrint "%, " p01.y to:file01
--	          formattedPrint "%\n" p01.z to:file01
	        )
	      )
		format "}\n" to:file01
		  format "\n" to:file01
/*	      if chk_n.checked==true do
	      (
	        format "normals \n"  to:file01
	        for j=1 to vnum do
	        (
	          local p01=[0,0,0]
	          p01=GetNormal selection[1].mesh j
	          format "% " p01.x to:file01
	          format "% " p01.y to:file01
	          format "%\n" p01.z to:file01
	        )
	      ) */
	      if chk_f.checked==true do
	      (
			local fnumb=getNumFaces selection[1].mesh
			  format "\n" to:file01
	         format "[Polygon] \n" fnum to:file01
			format "{\n" to:file01
			format "  NumOfP = " to:file01
	          format "%\n" fnumb to:file01
	          for p=1 to fnumb do
			(
				local p01=[0,0,0]
--				local PF=[0,0,0]
				p01=GetFace selection[1].mesh p
			--	local groupIDsUsed = #()
				local groupID  = getFaceSmoothGroup selection[1].mesh p as integer --WIP
               -- appendIfUnique groupIDsUsed groupID --WIP
				x01=(p01.x-1) as integer
				y01=(p01.y-1) as integer
				z01=(p01.z-1) as integer
				pp=(p-1) as integer
				--PF=GetTVert selection[1].mesh p
				format "  [" to:file01
				format "P" to:file01
				format "%" pp to:file01
				format "]\n" to:file01
				format "  {\n" to:file01
				format "    G = " to:file01 --WIP smooth group
				format "%\n" groupID to:file01
				format "    V0 = " to:file01
				format "%\n" x01 to:file01
				format "    V1 = " to:file01
				format "%\n" y01 to:file01
				format "    V2 = " to:file01
				format "%\n" z01 to:file01
				format "    M = 0\n" to:file01 --WIP material number
				--for f = 1 to fnumb do -- for each triangle
            --(
              local MappingFace = meshop.getMapFace selection[1].mesh 1 p
              local VertUVW = meshop.getMapVert selection[1].mesh 1 MappingFace.x
                --writeFloat file VertUVW.x
                --writeFloat file (0 - (VertUVW.y - 1))
				 uvwx = formattedPrint VertUVW.x format:"0 g"
				 uvwy = formattedPrint VertUVW.y format:"0 g"
				 fvarx = uvwx as float
				 fvary = uvwy as float
					format "    P0 =" to:file01
					format " %," fvarx to:file01 ---wip
					format " %\n" (0 - (fvary - 1)) to:file01 ---wip

			  local VertUVW = meshop.getMapVert selection[1].mesh 1 MappingFace.y
				--writeFloat file VertUVW.x
                --writeFloat file (0 - (VertUVW.y - 1))
				 uvwx = formattedPrint VertUVW.x format:"0 g"
				 uvwy = formattedPrint VertUVW.y format:"0 g"
				 fvarx = uvwx as float
				 fvary = uvwy as float
				    format "    P1 =" to:file01
					format " %," fvarx to:file01
					format " %\n" (0 - (fvary - 1)) to:file01

             local VertUVW = meshop.getMapVert selection[1].mesh 1 MappingFace.z
              --writeFloat file VertUVW.x
              --writeFloat file (0 - (VertUVW.y - 1))
				 uvwx = formattedPrint VertUVW.x format:"0 g"
				 uvwy = formattedPrint VertUVW.y format:"0 g"
				 fvarx = uvwx as float
				 fvary = uvwy as float
				   format "    P2 =" to:file01
				   format " %," fvarx to:file01
				   format " %\n" (0 - (fvary - 1)) to:file01
			--) 
				--format "    P0 = 0, 0\n" to:file01
				--format "    P1 = 0, 0\n" to:file01
				--format "    P2 = 0, 0\n" to:file01 --WIP
				format "  }\n"	to:file01				
			)
			format "}" to:file01
	      )
		  
		   
	      close file01
	    )
	)
)

    if selection.count<1 then MessageBox "Select object"
    if selection.count==1 do
    (
      --??????? ??????? ????
      m_roll=newrolloutfloater "JSD Exporter" 400 600

      addrollout roll_expmesh m_roll
    )
