$secret = $env:secret

Write-Host "plain_text_variable: $($env:plain_text_variable)"

Write-Host "secret_variable: $($secret)"

Write-Host "vertical secret_variable:"

$secret.ToCharArray()