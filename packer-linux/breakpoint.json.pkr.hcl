source "null" "debug" {
  communicator = "none"
}

build {
  sources = ["source.null.debug"]

  provisioner "shell-local" {
    inline = ["echo HI THERE !@!!"]
  }

  provisioner "breakpoint" {
    disable = false
    note    = "hey, this is a breakpoint"
  }

  provisioner "shell-local" {
    inline = ["echo JOB COMPLETED SUCCESSFULLY2"]
  }

}