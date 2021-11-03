#!/bin/bash

prenoms=(
Maria
Jose
Ana
Joao
Antonio
Francisco
Carlos
Paulo
Pedro
Lucas
Luiz
Marcos
Gabriel
Rafael
)

noms=(
Alves
Monteiro
Novaes
Mendes
Barros
Freitas
Barbosa
Pinto
Moura
Cavalcanti
Dias
Castro
Campos
Cardoso
Silva
Souza
Costa
Santos
Oliveira
Pereira
Rodrigues
Almeida
Nascimento
Lima
Araujo
Fernandes
Carvalho
Gomes
Martins
Rocha
Ribeiro
Rezende
)

genLine(){
    local name=$1
    local team=$2
    local age=$((RANDOM%100))
    # just the first character
    firstname=$(echo $name | cut -d ' ' -f1 | sed 's/\([A-Z]\).*/\1/g')
    lastname=$(echo $name | sed 's/.* //g')
    username=$(echo $firstname$lastname | tr '[A-Z]' '[a-z]')
    #echo $name $username $team $age
    #echo "$username|$name|$team|$age|/home/alunos/$username"
    echo "$username,$name,$team,$age,/home/alunos/$username"
}

# seed
RANDOM=$$

# total users
count=${1-10}

# generate groups
for i in $(seq 0 9)
do
    teams[$i]="inf200${i}"
done

for i in $(seq $count)
do
    prenom=${prenoms[$((RANDOM%${#prenoms[@]}))]}
    for j in $(seq 2)
    do
	nom[$j]=${noms[$((RANDOM % ${#noms[@]}))]}
    done
   allnames[i]="$prenom ${nom[@]}"
done

echo "login,name,group,age,home"
for n in "${allnames[@]}"
do
    team=${teams[$((RANDOM % ${#teams[@]}))]}
    genLine "$n" "$team"
done



