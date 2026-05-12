session_root "~"

if initialize_session "global"; then
  new_window "el_primero"

  new_window "el_segundo"
  select_window "el_primero"

fi

finalize_and_go_to_session
