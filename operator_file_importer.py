import bpy


def read_some_data(context, filepath, use_some_setting):
    print("running read_some_data...")
    f = open(filepath, 'r', encoding='utf-8')
    data = f #.read()
    #f.close()

    # would normally load the data here
    #print(data)
    
    numOfP = 0
    faces = []
    face = ()
    num1 = 0
    num2 = 0
    num3 = 0
    vert = ()
    vertices = []
    v = 0
    i = 0
    mats = []
    
    for line in data:
        if "[Material]" in line:
            print(" ")
            break
    
    for line in data:
        if "NumOfM" in line:
            print(" ")
            break

    for line in data:
        if "M" in line:
            #print(line)
            mats.append(line[line.find("=") + 1 : ].strip())
        elif "}" in line:
            break

    print(mats)
    print(len(mats))

    for line in data:
        if "NumOfV = " in line:
            print(line[line.find("=") + 1 : ].strip())
            numOfV = int(line[line.find("=") + 1 : ].strip())
            print(numOfV)
            print(type(numOfV))
            break


    for line in data:
        if "V" in line:
            vert = (line[line.find("=") + 1 : ].strip())
            vert = vert.split(", ", 2)
            v1 = float(vert[0])
            v2 = float(vert[1])
            v3 = float(vert[2])
            verts = (v1,v2,v3)
            vertices.append(verts)
        elif "}" in line:
            break

    print(vertices)

    for line in data:
        if "V" in line:
            if "V0" in line:
                num1 = int(line[line.find("=") + 1 : ].strip())
            elif "V1" in line:
                num2 = int(line[line.find("=") + 1 : ].strip())
            elif "V2" in line:
                num3 = int(line[line.find("=") + 1 : ].strip())
                nums = (num1,num2,num3)
                faces.append(nums)


    print(faces)

    mymesh = bpy.data.meshes.new("Cube")
    myobject = bpy.data.objects.new("Cube",  mymesh)

    myobject.location = bpy.context.scene.cursor_location
    bpy.context.scene.objects.link(myobject)

    mymesh.from_pydata(vertices,[],faces)
    mymesh.update(calc_edges=True)
    
    
    for number in mats:
        tex_red = bpy.ops.texture.new()
        #tex_red = bpy.data.textures.new('textex', type='IMAGE')
        #tex.image = bpy.data.images["ImageName"]
        mat_red = bpy.data.materials.new("red")
        mat_red.diffuse_color = (0.584314, 0.584314, 0.584314)
        mat_red.specular_color = (0.894118, 0.894118, 0.894118)
        mymesh.texture.append(tex_red)
        mymesh.materials.append(mat_red)
        
        import bpy

    def loadImage(imgName):
        img = bpy.data.add_image(imgName)
        tex = bpy.data.textures.new('TexName')
        tex.type = 'IMAGE' 
        print("Recast", tex, tex.type)
        tex = tex.recast_type()
        print("Done", tex, tex.type)
        tex.image = img
        mat = bpy.data.materials.new('MatName')
        mat.add_texture(texture = tex, texture_coordinates = 'ORCO', map_to = 'COLOR') 
        ob = bpy.context.object
        bpy.ops.object.material_slot_remove()
        me = ob.data
        me.add_material(mat)
    return

    loadImage('/home/thomas/picture.jpg')
        
    bpy.data.objects["Cube"].select = True # wip but works great
        
    #Loops per face
    #for face in mymesh.polygons:
    #    for vert_idx, loop_idx in zip(face.vertices, face.loop_indices):
    #        uv_coords = mymesh.uv_layers.active.data[loop_idx].uv
    #        print("face idx: %i, vert idx: %i, uvs: %f, %f" % (face.index, vert_idx, uv_coords.x, uv_coords.y))
    
    return {'FINISHED'}

# ImportHelper is a helper class, defines filename and
# invoke() function which calls the file selector.
from bpy_extras.io_utils import ImportHelper
from bpy.props import StringProperty, BoolProperty, EnumProperty
from bpy.types import Operator


class ImportSomeData(Operator, ImportHelper):
    """This appears in the tooltip of the operator and in the generated docs"""
    bl_idname = "import_test.some_data"  # important since its how bpy.ops.import_test.some_data is constructed
    bl_label = "Import Some Data"

    # ImportHelper mixin class uses this
    filename_ext = ".msh"

    filter_glob = StringProperty(
            default="*.msh",
            options={'HIDDEN'},
            maxlen=255,  # Max internal buffer length, longer would be clamped.
            )

    # List of operator properties, the attributes will be assigned
    # to the class instance from the operator settings before calling.
    use_setting = BoolProperty(
            name="Example Boolean",
            description="Example Tooltip",
            default=True,
            )

    type = EnumProperty(
            name="Example Enum",
            description="Choose between two items",
            items=(('OPT_A', "First Option", "Description one"),
                   ('OPT_B', "Second Option", "Description two")),
            default='OPT_A',
            )

    def execute(self, context):
        return read_some_data(context, self.filepath, self.use_setting)


# Only needed if you want to add into a dynamic menu
def menu_func_import(self, context):
    self.layout.operator(ImportSomeData.bl_idname, text="Text Import Operator")


def register():
    bpy.utils.register_class(ImportSomeData)
    bpy.types.INFO_MT_file_import.append(menu_func_import)


def unregister():
    bpy.utils.unregister_class(ImportSomeData)
    bpy.types.INFO_MT_file_import.remove(menu_func_import)


if __name__ == "__main__":
    register()

    # test call
    bpy.ops.import_test.some_data('INVOKE_DEFAULT')
