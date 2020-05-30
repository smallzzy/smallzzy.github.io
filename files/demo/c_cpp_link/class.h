#ifdef __cplusplus
class M {
    public:
    M(int i);
    void call(int k);
    private:
    int j;
};
#else 
typedef struct M M;
#endif


#ifdef __cplusplus
extern "C" {
#endif
extern M* m_create(int i);
extern void m_call(M* m, int k);
extern void m_destory(M*);
#ifdef __cplusplus
}
#endif
