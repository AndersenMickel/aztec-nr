use dep::aztec::{
    context::UnconstrainedContext, 
    state_vars::PrivateSet,
    note::{note_getter::view_notes, note_viewer_options::NoteViewerOptions}
};
use crate::value_note::ValueNote;

// Retrieves the total balance from a PrivateSet of ValueNotes, starting from the first note.
unconstrained pub fn get_balance(set: PrivateSet<ValueNote, UnconstrainedContext>) -> Field {
    get_balance_with_offset(set, 0)
}

// Recursively retrieves the total balance from a PrivateSet of ValueNotes,
// starting from the specified offset and accumulating the balance.
unconstrained pub fn get_balance_with_offset(set: PrivateSet<ValueNote, UnconstrainedContext>, offset: u32) -> Field {
    let mut balance = 0;
    
    // Initialize options for viewing notes
    let mut options = NoteViewerOptions::new();
    let notes = set.view_notes(options.set_offset(offset));
    
    // Accumulate balance from retrieved notes
    for i in 0..notes.len() {
        balance += notes.get_unchecked(i).value;
    }

    // Recursively retrieve additional notes if the limit was reached
    if notes.len() == options.limit {
        balance += get_balance_with_offset(set, offset + options.limit);
    }

    balance
}
