# Función para generar una clave a partir de una contraseña 
function GenerarClave {
    param (
        [string]$password
    )
    # Generar una clave de 256 bits (32 bytes) a partir de la contraseña
    $sha256 = [System.Security.Cryptography.SHA256]::Create()
    $clave = $sha256.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($password))
    return $clave
}

# Función para encriptar el contenido de un archivo
function EncriptarArchivo {
    param (
        [string]$archivo,
        [string]$password
    )
    $contenido = Get-Content -Path $archivo -Raw
    $bytesContenido = [System.Text.Encoding]::UTF8.GetBytes($contenido)
    $clave = GenerarClave -password $password
    
    $aes = [System.Security.Cryptography.Aes]::Create()
    $aes.Key = $clave
    $aes.GenerateIV()
    $iv = $aes.IV
    
    $encriptador = $aes.CreateEncryptor()
    $contenidoEncriptado = $encriptador.TransformFinalBlock($bytesContenido, 0, $bytesContenido.Length)
    
    $contenidoFinal = $iv + $contenidoEncriptado
    $archivoEncriptado = "$archivo.enc"
    [System.IO.File]::WriteAllBytes($archivoEncriptado, $contenidoFinal)
    
    Remove-Item $archivo
    Write-Output "Archivo encriptado exitosamente como $archivoEncriptado"
}

# Función para desencriptar el contenido de un archivo
function DesencriptarArchivo {
    param (
        [string]$archivo,
        [string]$password
    )
    $contenidoEncriptado = [System.IO.File]::ReadAllBytes($archivo)
    $clave = GenerarClave -password $password
    
    $aes = [System.Security.Cryptography.Aes]::Create()
    $aes.Key = $clave
    $iv = $contenidoEncriptado[0..15]
    $datosEncriptados = $contenidoEncriptado[16..($contenidoEncriptado.Length - 1)]
    $aes.IV = $iv
    
    $desencriptador = $aes.CreateDecryptor()
    
    try {
        $contenidoDesencriptado = $desencriptador.TransformFinalBlock($datosEncriptados, 0, $datosEncriptados.Length)
        $contenido = [System.Text.Encoding]::UTF8.GetString($contenidoDesencriptado)
        
        $archivoDesencriptado = $archivo -replace '\.enc$', '.txt'
        Set-Content -Path $archivoDesencriptado -Value $contenido -Force
        Write-Output "Archivo desencriptado exitosamente como $archivoDesencriptado"
    } catch {
        Write-Output "Contraseña incorrecta o el archivo no es válido."
    }
}

# Función para solicitar contraseña usando una ventana emergente
function SolicitarContrasena {
    param (
        [string]$mensaje
    )
    Add-Type -AssemblyName System.Windows.Forms
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Kodovka - Solicitud de Contraseña"
    $form.Size = New-Object System.Drawing.Size(300,150)
    $form.StartPosition = "CenterScreen"

    $label = New-Object System.Windows.Forms.Label
    $label.Text = $mensaje
    $label.AutoSize = $true
    $label.Location = New-Object System.Drawing.Point(10,20)
    $form.Controls.Add($label)

    $textbox = New-Object System.Windows.Forms.TextBox
    $textbox.UseSystemPasswordChar = $true
    $textbox.Location = New-Object System.Drawing.Point(10,50)
    $textbox.Width = 260
    $form.Controls.Add($textbox)

    $buttonOk = New-Object System.Windows.Forms.Button
    $buttonOk.Text = "Aceptar"
    $buttonOk.Location = New-Object System.Drawing.Point(100,80)
    $buttonOk.Add_Click({$form.Close()})
    $form.Controls.Add($buttonOk)

    $form.ShowDialog() | Out-Null
    return $textbox.Text
}

# Ruta del archivo a encriptar/desencriptar
if ($args.Length -eq 1) {
    $archivo = $args[0]
} else {
    $archivo = Read-Host "Ingrese la ruta del archivo que desea procesar"
}

# Verificar si el archivo tiene la extensión .enc (indica que está encriptado)
if ($archivo -match '\.enc$') {
    # El archivo está encriptado, preguntar si desea desencriptarlo
    $respuesta = Read-Host "El archivo está encriptado. ¿Desea desencriptarlo? (s/n)"
    if ($respuesta -eq 's') {
        $password = SolicitarContrasena -mensaje "El archivo está encriptado. Ingrese la contraseña para desencriptarlo"
        DesencriptarArchivo -archivo $archivo -password $password
    } else {
        Write-Output "No se ha desencriptado el archivo."
    }
} else {
    # El archivo no está encriptado, preguntar si desea encriptarlo
    $respuesta = Read-Host "El archivo no está encriptado. ¿Desea encriptarlo? (s/n)"
    
    if ($respuesta -eq 's') {
        $password = SolicitarContrasena -mensaje "Ingrese una contraseña para encriptar el archivo"
        EncriptarArchivo -archivo $archivo -password $password
    } else {
        Write-Output "No se ha encriptado el archivo."
    }
}

# Comandos para ejecutar el script:
# Para encriptar o desencriptar el archivo con el script Kodovka.ps1, navegue al directorio del script en PowerShell y ejecute:
# powershell -ExecutionPolicy Bypass -File .\Kodovka.ps1 "ruta\del\archivo.enc"
# Esto abrirá las ventanas correspondientes para encriptar o desencriptar el archivo.
