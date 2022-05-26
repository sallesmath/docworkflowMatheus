#################### An�lises Doutorado Matheus ######################
##################### PPGZoologia UFPR  #########################
############## Departamento de Zoologia ################

## Me. Matheus Maciel Alcantara Salles - PPGZoo - UFPR
## matheusmaciel.salles@gmail.com

### Carregar pacote "usethis"
library(usethis)

# projeto
usethis::create_project("C:/Users/mathe/OneDrive/docworkflowMatheus")
# pacote
usethis::create_package("/Volumes/Samsung SSD/neanderh/Documents/pCloud/Disciplinas-Cursos-R/Disciplina-Ciencia_replicavel_pacotesR/Ciencia_replicavel_pacotesR-Material_alunos/testPackage")

### Adicionando git ao projeto
usethis::use_git()
# escolha se quer fazer o commit dos arquivos.
# Se sim: Definitely ou Absolutely ou Yeah...

# escolha a opção para reiniciar o RStudio


### Configurando o github no projeto,
# Vai criar o repositório na conta
# argumentos private e visibility pra alterar a visibilidade do repositório
usethis::use_github()
# Repositório criado!

## Algumas precauções
# Get a situation report on your current Git/GitHub status.
# Useful for diagnosing problems.
usethis::git_sitrep()

# Vaccinate your global gitignore file
# Adds .DS_Store, .Rproj.user, .Rdata, .Rhistory, and .httr-oauth to your
# global (a.k.a. user-level) .gitignore. This is good practice as it
# decreases the chance that you will accidentally leak credentials to GitHub
usethis::git_vaccinate()