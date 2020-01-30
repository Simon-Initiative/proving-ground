export const classNames = (names: string | string[]) => {
    if (typeof names === 'string') {
      return names.trim();
    }
  
    return names.filter(n => n).join(' ');
  };
  