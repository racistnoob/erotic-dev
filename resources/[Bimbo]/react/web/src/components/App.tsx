import React, { useState } from 'react';
import './App.css';
import { debugData } from '../utils/debugData';
import { fetchNui } from '../utils/fetchNui';
import { useNuiEvent } from '../hooks/useNuiEvent';

debugData([
  {
    action: 'setVisible',
    data: true,
  },
]);

interface Lobby {
  id: number;
  name: string;
  description: string;
}

const App: React.FC = () => {
  const [lobbies] = useState<Lobby[]>([
    {
      id: 1,
      name: 'Southside #1',
      description: '| FPS Vehicles |',
    },
    {
      id: 2,
      name: 'Southside #2',
      description: '| FPS Vehicles |',
    },
    {
      id: 3,
      name: 'Southside #3',
      description: '| FPS Vehicles |',
    },
    {
      id: 4,
      name: 'Southside #4',
      description: '| FPS Vehicles |',
    },
    {
      id: 5,
      name: 'Southside #5',
      description: '| FPS Vehicles | HeadShots |',
    },
    {
      id: 6,
      name: 'Southside #6',
      description: '| FPS Vehicles | HeadShots |',
    },
    {
      id: 7,
      name: 'Southside #7',
      description: '| FPS Vehicles | HeadShots |',
    },
    {
      id: 8,
      name: 'Southside #8',
      description: '| FPS Vehicles | HeadShots |',
    },
    {
      id: 9,
      name: 'Southside #9',
      description: '',
    },
    {
      id: 10,
      name: 'Southside #10',
      description: '',
    },
    {
      id: 11,
      name: 'Southside #11',
      description: '',
    },
    {
      id: 12,
      name: 'Southside #12',
      description: '',
    },
    {
      id: 13,
      name: 'Southside #13',
      description: '',
    },
    {
      id: 14,
      name: 'Southside #14',
      description: '',
    },
    {
      id: 15,
      name: 'Southside #15',
      description: '',
    },
    {
      id: 16,
      name: 'Southside #16',
      description: '',
    },
    {
      id: 17,
      name: 'Southside #17',
      description: '',
    },
    {
      id: 18,
      name: 'Southside #18',
      description: '',
    },
    {
      id: 19,
      name: 'Southside #19',
      description: '',
    },
    {
      id: 20,
      name: 'Southside #20',
      description: '',
    },
  ]);

  const handleJoinLobby = (lobbyId: number) => {
    fetchNui('switchWorld', { worldId: lobbyId })
      .then((response) => {
        if (response.success) {
          console.log('Joined lobby successfully!');
        } else {
          console.error('Failed to join the lobby:', response.error);
        }
      })
      .catch((error) => {
        console.error('Failed to join the lobby:', error);
      });
  };  

  return (
    <div className='overlay'>
    <div className="lobby-container">
      <div className="lobby-list">
        <div className="custom-lobby">
          <button className="create-lobby-button">SoonTM
          </button>
          <button className="create-lobby-button">SoonTM
          </button>
        </div>
        {lobbies.map((lobby) => (
          <div key={lobby.id} className="lobby-item" onClick={() => handleJoinLobby(lobby.id)}>
            <div className="lobby-info">
              <h3 className="lobby-title">{lobby.name}</h3>
              <p className="lobby-description">{lobby.description}</p>
            </div>
          </div>
        ))}
      </div>
    </div>
    </div>
  );
};

export default App;
