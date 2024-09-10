# Include this function to autoload in zsh/bash profile
function kktl(){
  array=()
  while IFS= read -r line; do
    array+=("$line")
  done < <( kubectl get pods -n $1)  # Eating command

# fzf message and listing
  echo "Выберите элемент из списка:"
  item=$(printf '%s\n' "${array[@]}" | fzf --height 40% --border --ansi)
  name=$1
  # Проверить, что выбран элемент
  if [[ -n $item ]]; then

    echo "Вы выбрали: $item"
    first_word=$(echo "$item" | sed -E 's/^([a-zA-Z0-9-]+).*/\1/')

    # Выполнить подключение для подов по очереди, пока не найдется необходимое имя
    echo "Выполняем команду с выбранным элементом..."
    kubectl -n $name exec -it $first_word -c app -- bash || kubectl -n $name exec -it $first_word -c backend -- bash || kubectl -n $name exec -it $first_word -c mysql  -- bash
  
    # your_command "$item"  # Замените `your_command` на вашу команду
  else
    echo "Вы не выбрали элемент."
  fi
}
