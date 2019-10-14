import { TestBed } from '@angular/core/testing';

import { RivescriptFilesService } from './rivescript-files.service';

describe('RivescriptFilesService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: RivescriptFilesService = TestBed.get(RivescriptFilesService);
    expect(service).toBeTruthy();
  });
});
