import { describe, it, expect, beforeEach, vi } from 'vitest';
import { render, screen, waitFor } from '@testing-library/react';
import axios from 'axios';
import App from './App.jsx';

vi.mock('axios');

describe('App Component', () => {
  beforeEach(() => {
    // Mock portfolio endpoint
    vi.mocked(axios.get).mockResolvedValueOnce({
      data: {
        data: {
          name: 'John Doe',
          title: 'Full Stack Developer',
          bio: 'Test bio',
          skills: ['JavaScript', 'React'],
        },
      },
    });
    
    // Mock projects endpoint
    vi.mocked(axios.get).mockResolvedValueOnce({
      data: {
        data: [],
      },
    });
  });

  it('renders loading state initially', () => {
    render(<App />);
    expect(screen.getByText(/loading/i)).toBeInTheDocument();
  });

  it('renders portfolio data after loading', async () => {
    render(<App />);
    
    await waitFor(() => {
      expect(screen.getByText('John Doe')).toBeInTheDocument();
    });
    
    expect(screen.getByText('Full Stack Developer')).toBeInTheDocument();
  });
});
