typedef struct int_matrix int_matrix; // Incomplete type: let's the preprocessor 
                                    // be happy with seeing this type

void initialise_matrix(int nrows, int ncols, int_matrix *m);
int_matrix* new_int_matrix(int nrows, int ncols);
void dealloc_matrix(int_matrix* m);
void delete_matrix(int_matrix* m);
void set_element(int data, int row, int col, int_matrix *m);
int get_element(int row, int col, int_matrix *m);
int main(void);
