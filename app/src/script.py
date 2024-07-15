from rdkit import Chem
from rdkit.Chem import AllChem
import trimesh

def smiles_to_glb(smiles, output_file):
    mol = Chem.MolFromSmiles(smiles)
    mol = Chem.AddHs(mol)
    AllChem.EmbedMolecule(mol)
    AllChem.UFFOptimizeMolecule(mol)

    conf = mol.GetConformer()
    atoms = []
    bonds = []
    for atom in mol.GetAtoms():
        pos = conf.GetAtomPosition(atom.GetIdx())
        atoms.append({
            "element": atom.GetSymbol(),
            "x": pos.x,
            "y": pos.y,
            "z": pos.z
        })
        
    for bond in mol.GetBonds():
        start = bond.GetBeginAtomIdx()
        end = bond.GetEndAtomIdx()
        type = bond.GetBondType()
        bonds.append({"start": start, "end": end, "type": type})
        print(f"start: {start}, end: {end}, type: {type}")
        

    spheres = []
    for atom in atoms:
        sphere = trimesh.creation.uv_sphere(radius=0.4)
        sphere.visual.vertex_colors = [255, 0, 0] if atom["element"] == "C" else [0, 255, 0]
        sphere.apply_translation([atom["x"], atom["y"], atom["z"]])
        spheres.append(sphere)
     
    cylinders = []   
    for bond in bonds:
        startX = atoms[bond["start"]]["x"]
        startY = atoms[bond["start"]]["y"]
        startZ = atoms[bond["start"]]["z"]
        endX = atoms[bond["end"]]["x"]
        endY = atoms[bond["end"]]["y"]
        endZ = atoms[bond["end"]]["z"]
        cylinder = trimesh.creation.cylinder(radius=0.15 ,segment=[[startX, startY, startZ], [endX, endY, endZ]])
        cylinder.visual.vertex_colors = [255, 255, 255]
        cylinders.append(cylinder)
        
    objects = spheres + cylinders
    scene = trimesh.Scene(objects)
    scene.export(output_file, file_type='glb')


def main():
    smiles = 'CN=C=O'
    output_file = 'test.glb'
    smiles_to_glb(smiles, output_file)
    print("---------------------makeGlb---------------------")

if __name__ == '__main__':
    main()
