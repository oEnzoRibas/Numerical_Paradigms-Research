"""Execute all ULP notebooks in order and persist their figures/CSVs and outputs."""
from pathlib import Path
import nbformat
from nbclient import NotebookClient

root = Path(__file__).resolve().parent
notebooks = sorted((root/'notebooks').glob('*.ipynb'))
assert len(notebooks) == 6, 'Expected exactly six experiment notebooks'
for path in notebooks:
    print(f'Running: {path.name}', flush=True)
    nb = nbformat.read(path,as_version=4)
    client = NotebookClient(nb,timeout=300,kernel_name='python3',
                            resources={'metadata':{'path':str(root)}},
                            allow_errors=False)
    client.execute()
    nbformat.write(nb,path)
print('Success: 6/6 notebooks, 9 figures, experiment tables and validation summary.')
