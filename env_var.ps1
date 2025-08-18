# -------------------------------
# PowerShell script to create or update a Conda environment,
# install packages, and register it in JupyterLab
# -------------------------------

# === User settings ===
$envName = "modeling_env" 
$pythonVersion = "3.11" 
$packages = @(
    "jupyterlab",
    "ipykernel",
    "pandas",
    "scikit-learn",
    "matplotlib",
    "seaborn"
)

# -------------------------------
# 1. Check if environment exists
# -------------------------------
$envs = conda env list | ForEach-Object { ($_ -split '\s+')[0] }
if ($envs -contains $envName) {
    Write-Host "Environment '$envName' already exists. Skipping creation."
} else {
    Write-Host "Creating environment '$envName' with Python $pythonVersion..."
    conda create -n $envName python=$pythonVersion -y
}

# -------------------------------
# 2. Activate the environment
# -------------------------------
Write-Host "Activating environment '$envName'..."
conda activate $envName

# -------------------------------
# 3. Install packages
# -------------------------------
Write-Host "Installing packages..."
foreach ($pkg in $packages) {
    conda install -c conda-forge $pkg -y
}

# -------------------------------
# 4. Register environment as Jupyter kernel
# -------------------------------
Write-Host "Registering '$envName' as a Jupyter kernel..."
python -m ipykernel install --user --name=$envName --display-name "Python ($envName)"

Write-Host "Environment '$envName' is ready and available in JupyterLab!"
