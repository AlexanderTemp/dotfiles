session_root "~/Desktop/auditorias/new/"

if initialize_session "audit"; then
  new_window "editor"

  new_window "dev"
  run_cmd "cd ./audit-final2"
  run_cmd "d start atr_postgres atr_redis"
  run_cmd "g sw develop && g pod && npm run db:fresh && npm run start"
  split_h 50

  select_pane 2
  run_cmd "cd ./frontend-v2"
  run_cmd "g sw main && g pom && bun dev"

  new_window "extra"

  select_window "editor"
  run_cmd "cd ./frontend-v2"

fi

finalize_and_go_to_session
