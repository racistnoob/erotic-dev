window.addEventListener('message', function(event) {
  // Check for the 'updateLobbies' action
  if (event.data.action === 'updateLobbies') {
    const lobbies = event.data.lobbies;
    // Clear the existing lobbies
    const lobbiesContainer = document.getElementById('lobbies-container');
    lobbiesContainer.innerHTML = '';

    // Add each lobby to the UI
    lobbies.forEach(lobby => {
      addLobby(lobby.id, lobby.name, lobby.description);
    });
  }
});

function toggleDropdown(dropdownId) {
    var dropdown = document.getElementById(dropdownId);
    var isVisible = dropdown.style.display === 'block';
    dropdown.style.display = isVisible ? 'none' : 'block';
  }


  document.addEventListener('DOMContentLoaded', () => {
    // This function could be called whenever you receive new lobby data
    function addLobby(lobbyId, lobbyName, lobbyDescription) {
      const lobbiesContainer = document.getElementById('lobbies-container');
      
      // Create the elements needed for the lobby
      const arenaDiv = document.createElement('div');
      arenaDiv.className = 'arena';
      arenaDiv.id = lobbyId;
      
      const h2 = document.createElement('h2');
      h2.textContent = lobbyName;
      
      const descriptionDiv = document.createElement('div');
      descriptionDiv.className = 'description';
      descriptionDiv.textContent = lobbyDescription;
  
      // Append the lobby elements to the container
      arenaDiv.appendChild(h2);
      arenaDiv.appendChild(descriptionDiv);
      lobbiesContainer.appendChild(arenaDiv);
      
      // Attach event listener for the dropdown
      arenaDiv.addEventListener('click', () => toggleDropdown(`${lobbyId}-dropdown`));
    }
  
    // Example usage:
    // addLobby('pistol', 'PvP Arena - Pistol', 'A thrilling pistol-only battle arena.');
    // You would call addLobby for each lobby you have data for
  });
  