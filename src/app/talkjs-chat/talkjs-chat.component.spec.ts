import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TalkjsChatComponent } from './talkjs-chat.component';

describe('TalkjsChatComponent', () => {
  let component: TalkjsChatComponent;
  let fixture: ComponentFixture<TalkjsChatComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [TalkjsChatComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(TalkjsChatComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
