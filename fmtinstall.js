function copyFmtInstallationScript(textId) {
  /* Get the text field */
  var copyText = document.getElementById(textId);

  /* Select the text field */
  copyText.select();
  copyText.setSelectionRange(0, 99999); /* For mobile devices */

   /* Copy the text inside the text field */
  navigator.clipboard.writeText(copyText.value);

  /* Alert the copied text */
  alert("Text \"" + copyText.value + "\" copied to the clipboard");
}
