// https://github.com/maciej-gurban/responsive-bootstrap-toolkit#basic-usage
// Wrap IIFE around your code
(function($, viewport){
  $(document).ready(function() {
    const episodeColumn = document.querySelector("#episode-column");
    const management = document.querySelector("#manage-shows");

    const setEqualHeight = () => {
      const height = episodeColumn.offsetHeight;
      management.style.height = `${height}px`;
    }
    const setIndependantHeight = () => {
      management.style.height = 'auto';
    }


    if(viewport.is('<=sm')) {
      setIndependantHeight();
    }
    else {
      setEqualHeight();
    }


    // Execute code each time window size changes
    $(window).resize(
      viewport.changed(function() {
        if(viewport.is('<=sm')) {
          setIndependantHeight();        }
        else {
          setEqualHeight();
        }
      }, 150) // custom debounce interval
      );
  });
})(jQuery, ResponsiveBootstrapToolkit);
