
menu() {
  printf "1. filebrowser\n"
  printf "2. window\n"
  printf "3. run\n"
  printf "4. ssh\n"
  printf "5. radio\n"

}

main() {
  choice=$(menu | rofi -dmenu | cut -d. -f1)

  case $choice in
    1)
      cmd="rofi -show filebrowser"
      break
      ;;
    2)
      cmd="rofi -show window"
      break
      ;;
    3)
      cmd="rofi -show run"
      break
      ;;
    4)
      cmd="rofi -show ssh"
      break
      ;;
    5)
      cmd="rofi-beats"
      break
      ;;
  esac

  $cmd
}

main
